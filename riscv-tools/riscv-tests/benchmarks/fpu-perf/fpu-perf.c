// See LICENSE for license details.

#pragma GCC optimize ("no-inline")



#include "fpu-perf.h"
#include "util.h"

#include <math.h>



#ifndef REG
        Boolean Reg = false;
#define REG
        /* REG becomes defined as empty */
        /* i.e. no register variables   */
#else
        Boolean Reg = true;
#undef REG
#define REG register
#endif


long            Begin_Time,
                End_Time,
                User_Time;

/* end of variables for time measurement */


int main (int argc, char** argv)
/*****/
  /* main program, corresponds to procedures        */
{



  printf("\n");
  if (Reg)
  {
    printf("Program compiled with 'register' attribute\n");
  }
  else
  {
    printf("Program compiled without 'register' attribute\n");
  }
  printf("Using %s, HZ=%d\n", CLOCK_TYPE, HZ);
  printf("\n");


  // Bob: here we add code to try if the floating point F/D can be compiled and executed correctly
  // Since it is not in the main benchmark loop we can ignore the impact of it to the DMIPS

  setStats(1);
  Start_Timer();
  int fp_loop_cnt;
  float  sp_Arr[100];
  double dp_Arr[100];

  double dp_add_Arr[100];
  double dp_mul_Arr[100];
  double dp_mac_Arr[100];
  double dp_div_Arr[100];
  double dp_sqrt_Arr[100];
  double dp_mac_sum = 0;
  float sp_add_Arr[100];
  float sp_mul_Arr[100];
  float sp_mac_Arr[100];
  float sp_div_Arr[100];
  float sp_sqrt_Arr[100];
  float sp_mac_sum = 0;
  float sum;
  long long_sum;
  //
  // Initlize the sp and dp array
  sp_Arr[0] = 269.683544591;
  dp_Arr[0] = 430.324932668;
  for (fp_loop_cnt = 1; fp_loop_cnt < 100; fp_loop_cnt++){
      sp_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt-1]+0.1; 
      dp_Arr[fp_loop_cnt] = dp_Arr[fp_loop_cnt-1]+0.1; 
  }
  //
  // add two array
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      dp_add_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] + dp_Arr[fp_loop_cnt];
      sp_add_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] + sp_Arr[fp_loop_cnt];
  }
  //
  // mul two array
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      dp_mul_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] * dp_Arr[fp_loop_cnt];
      sp_mul_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] * sp_Arr[fp_loop_cnt];
  }
  //
  // mac two array
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      dp_mac_sum = (sp_Arr[fp_loop_cnt] * dp_Arr[fp_loop_cnt]) + dp_mac_sum;
      sp_mac_sum = (sp_Arr[fp_loop_cnt] * sp_Arr[fp_loop_cnt]) + sp_mac_sum;
  }
  //
  // div two array
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      dp_div_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] / dp_Arr[fp_loop_cnt];
      sp_div_Arr[fp_loop_cnt] = sp_Arr[fp_loop_cnt] / sp_Arr[fp_loop_cnt];
  }
  //
  // sqrt one array
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      dp_sqrt_Arr[fp_loop_cnt] = sqrt(dp_Arr[fp_loop_cnt]);
      sp_sqrt_Arr[fp_loop_cnt] = sqrt(sp_Arr[fp_loop_cnt]);
  }
  //
  sum = dp_mac_sum + sp_mac_sum;
  // sum all of them in case it is optimized away
  for (fp_loop_cnt = 0; fp_loop_cnt < 100; fp_loop_cnt++){
      sum = sum + dp_add_Arr[fp_loop_cnt] 
                + dp_mul_Arr[fp_loop_cnt] 
                + dp_mac_Arr[fp_loop_cnt] 
                + dp_div_Arr[fp_loop_cnt] 
                + dp_sqrt_Arr[fp_loop_cnt] 
                + sp_add_Arr[fp_loop_cnt] 
                + sp_mul_Arr[fp_loop_cnt] 
                + sp_mac_Arr[fp_loop_cnt] 
                + sp_div_Arr[fp_loop_cnt] 
                + sp_sqrt_Arr[fp_loop_cnt];
  }

  Stop_Timer();
  setStats(0);

  User_Time = End_Time - Begin_Time;
  long_sum = (long) sum;
  printf("Value of long_sum is: %ld\n", long_sum);
  printf("Cycles for 100 loops run : %ld\n", User_Time);

  return 0;
}



