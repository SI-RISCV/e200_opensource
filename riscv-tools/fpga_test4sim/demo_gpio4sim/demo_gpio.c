// See LICENSE for license details.

#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include <string.h>
#include "plic/plic_driver.h"
#include "encoding.h"
#include <unistd.h>
#include "stdatomic.h"

void reset_demo (void);

// Structures for registering different interrupt handlers
// for different parts of the application.
typedef void (*function_ptr_t) (void);

void no_interrupt_handler (void) {};

function_ptr_t g_ext_interrupt_handlers[PLIC_NUM_INTERRUPTS];


// Instance data for the PLIC.

plic_instance_t g_plic;


/*Entry Point for PLIC Interrupt Handler*/
void handle_m_ext_interrupt(){
  plic_source int_num  = PLIC_claim_interrupt(&g_plic);
  if ((int_num >=1 ) && (int_num < PLIC_NUM_INTERRUPTS)) {
    g_ext_interrupt_handlers[int_num]();
  }
  else {
    exit(1 + (uintptr_t) int_num);
  }
  PLIC_complete_interrupt(&g_plic, int_num);
}


/*Entry Point for Machine Timer Interrupt Handler*/
void handle_m_time_interrupt(){

  clear_csr(mie, MIE_MTIE);

  // Reset the timer for 3s in the future.
  // This also clears the existing timer interrupt.

  volatile uint64_t * mtime       = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIME);
  volatile uint64_t * mtimecmp    = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIMECMP);
  uint64_t now = *mtime;
  uint64_t then = now + 0.5 * RTC_FREQ;
  *mtimecmp = then;


  GPIO_REG(GPIO_OUTPUT_VAL) ^= (0x1 << RED_LED_GPIO_OFFSET);
  
  // Re-enable the timer interrupt.
  set_csr(mie, MIE_MTIE);

}

static void _putc(char c) {
  while ((int32_t) UART0_REG(UART_REG_TXFIFO) < 0);
  UART0_REG(UART_REG_TXFIFO) = c;
}

int _getc(char * c){
  int32_t val = (int32_t) UART0_REG(UART_REG_RXFIFO);
  if (val > 0) {
    *c =  val & 0xFF;
    return 1;
  }
  return 0;
}

char * read_instructions_msg= " \
\n\
 ";


const char * printf_instructions_msg= " \
\n\
\n\
\n\
\n\
This is printf function printed:  \n\
\n\
             !! Here We Go, HummingBird !! \n\
\n\
     ######    ###    #####   #####          #     #\n\
     #     #    #    #     # #     #         #     #\n\
     #     #    #    #       #               #     #\n\
     ######     #     #####  #        #####  #     #\n\
     #   #      #          # #                #   #\n\
     #    #     #    #     # #     #           # #\n\
     #     #   ###    #####   #####             #\n\
\n\
 ";
const char * instructions_msg_sirv = " \
\n\
\n\
\n\
\n\
          #    #  ######  #####   ######\n\
          #    #  #       #    #  #\n\
          ######  #####   #    #  #####\n\
          #    #  #       #####   #\n\
          #    #  #       #   #   #\n\
          #    #  ######  #    #  ######\n\
\n\
\n\
                  #    #  ######\n\
                  #    #  #\n\
                  #    #  #####\n\
                  # ## #  #\n\
                  ##  ##  #\n\
                  #    #  ######\n\
\n\
\n\
                   ####    ####\n\
                  #    #  #    #\n\
                  #       #    #\n\
                  #  ###  #    #\n\
                  #    #  #    #\n\
                   ####    ####\n\
\n\
\n\
                !! HummingBird !! \n\
\n\
   ######    ###    #####   #####          #     #\n\
   #     #    #    #     # #     #         #     #\n\
   #     #    #    #       #               #     #\n\
   ######     #     #####  #        #####  #     #\n\
   #   #      #          # #                #   #\n\
   #    #     #    #     # #     #           # #\n\
   #     #   ###    #####   #####             #\n\
\n\
 ";




void button_1_handler(void) {

  // Green LED On
  GPIO_REG(GPIO_OUTPUT_VAL) |= (1 << GREEN_LED_GPIO_OFFSET);

  // Clear the GPIO Pending interrupt by writing 1.
  GPIO_REG(GPIO_RISE_IP) = (0x1 << BUTTON_1_GPIO_OFFSET);

};


void button_2_handler(void) {

  // Blue LED On
  GPIO_REG(GPIO_OUTPUT_VAL) |= (1 << BLUE_LED_GPIO_OFFSET);

  GPIO_REG(GPIO_RISE_IP) = (0x1 << BUTTON_2_GPIO_OFFSET);

};

void register_plic_irqs (){

   /**************************************************************************
   * Set up the PLIC
   *
   *************************************************************************/
  PLIC_init(&g_plic,
	    PLIC_CTRL_ADDR,
	    PLIC_NUM_INTERRUPTS,
	    PLIC_NUM_PRIORITIES);


  for (int ii = 0; ii < PLIC_NUM_INTERRUPTS; ii ++){
    g_ext_interrupt_handlers[ii] = no_interrupt_handler;
  }

  g_ext_interrupt_handlers[PLIC_INT_DEVICE_BUTTON_1] = button_1_handler;
  g_ext_interrupt_handlers[PLIC_INT_DEVICE_BUTTON_2] = button_2_handler;


  // Have to enable the interrupt both at the GPIO level,
  // and at the PLIC level.
  PLIC_enable_interrupt (&g_plic, PLIC_INT_DEVICE_BUTTON_1);
  PLIC_enable_interrupt (&g_plic, PLIC_INT_DEVICE_BUTTON_2);

  // Priority must be set > 0 to trigger the interrupt.
  PLIC_set_priority(&g_plic, PLIC_INT_DEVICE_BUTTON_1, 1);
  PLIC_set_priority(&g_plic, PLIC_INT_DEVICE_BUTTON_2, 1);

 } 


void setup_mtime (){

    // Set the machine timer to go off in 3 seconds.
    // The
    volatile uint64_t * mtime       = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIME);
    volatile uint64_t * mtimecmp    = (uint64_t*) (CLINT_CTRL_ADDR + CLINT_MTIMECMP);
    uint64_t now = *mtime;
    uint64_t then = now + 10 * RTC_FREQ;
    *mtimecmp = then;

}

int main(int argc, char **argv)
{
  // Set up the GPIOs such that the LED GPIO
  // can be used as both Inputs and Outputs.
  

  GPIO_REG(GPIO_OUTPUT_EN)  &= ~((0x1 << BUTTON_1_GPIO_OFFSET) | (0x1 << BUTTON_2_GPIO_OFFSET));
  GPIO_REG(GPIO_PULLUP_EN)  &= ~((0x1 << BUTTON_1_GPIO_OFFSET) | (0x1 << BUTTON_2_GPIO_OFFSET));
  GPIO_REG(GPIO_INPUT_EN)   |=  ((0x1 << BUTTON_1_GPIO_OFFSET) | (0x1 << BUTTON_2_GPIO_OFFSET));

  GPIO_REG(GPIO_RISE_IE) |= (1 << BUTTON_1_GPIO_OFFSET);
  GPIO_REG(GPIO_RISE_IE) |= (1 << BUTTON_2_GPIO_OFFSET);


  GPIO_REG(GPIO_INPUT_EN)    &= ~((0x1<< RED_LED_GPIO_OFFSET) | (0x1<< GREEN_LED_GPIO_OFFSET) | (0x1 << BLUE_LED_GPIO_OFFSET)) ;
  GPIO_REG(GPIO_OUTPUT_EN)   |=  ((0x1<< RED_LED_GPIO_OFFSET)| (0x1<< GREEN_LED_GPIO_OFFSET) | (0x1 << BLUE_LED_GPIO_OFFSET)) ;

  GPIO_REG(GPIO_OUTPUT_VAL)  |=   (0x1 << RED_LED_GPIO_OFFSET) ;
  GPIO_REG(GPIO_OUTPUT_VAL)  &=  ~((0x1<< BLUE_LED_GPIO_OFFSET) | (0x1<< GREEN_LED_GPIO_OFFSET)) ;


  
  // Print the message
  printf ("%s",instructions_msg_sirv);

  //Bob: for simulation, we comment it off
  //printf ("%s","\nPlease enter any letter from keyboard to continue!\n");

  //char c;
  //// Check for user input
  //while(1){
  //  if (_getc(&c) != 0){
  //     printf ("%s","I got an input, it is\n\r");
  //     break;
  //  }
  //}
  //_putc(c);
  //printf ("\n\r");
  //printf ("%s","\nThank you for supporting RISC-V, you will see the blink soon on the board!\n");

  


  // Disable the machine & timer interrupts until setup is done.
  clear_csr(mie, MIE_MEIE);
  clear_csr(mie, MIE_MTIE);

  register_plic_irqs();

  setup_mtime();

  // Enable the Machine-External bit in MIE
  set_csr(mie, MIE_MEIE);
  // Enable the Machine-Timer bit in MIE
  set_csr(mie, MIE_MTIE);
  // Enable interrupts in general.
  set_csr(mstatus, MSTATUS_MIE);


  /**************************************************************************
   * Demonstrate fast GPIO bit-banging.
   * One can bang it faster than this if you know
   * the entire OUTPUT_VAL that you want to write, but 
   * Atomics give a quick way to control a single bit.
   *************************************************************************/
    
  // For Bit-banging with Atomics demo.
  
  uint32_t bitbang_mask = 0;
  bitbang_mask = (1 << 13);

  GPIO_REG(GPIO_OUTPUT_EN) |= bitbang_mask;

  // For Bit-banging with Atomics demo.
  
  while (1){
    atomic_fetch_xor_explicit(&GPIO_REG(GPIO_OUTPUT_VAL), bitbang_mask, memory_order_relaxed);
  }

  return 0;

}
