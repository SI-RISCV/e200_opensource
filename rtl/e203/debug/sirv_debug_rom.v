 /*                                                                      
 Copyright 2018 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The module for debug ROM program
//
// ====================================================================

module sirv_debug_rom(
  input  [7-1:2] rom_addr, 
  output [32-1:0] rom_dout  
  );
        
  // These ROM contents support only RV32 
  // See $RISCV/riscv-tools/riscv-isa-sim/debug_rom/debug_rom.h/S
  // The code assumes only 28 bytes of Debug RAM.

  // def xlen32OnlyRomContents : Array[Byte] = Array(
  // 0x6f, 0x00, 0xc0, 0x03, 0x6f, 0x00, 0xc0, 0x00, 0x13, 0x04, 0xf0, 0xff,
  // 0x6f, 0x00, 0x80, 0x00, 0x13, 0x04, 0x00, 0x00, 0x0f, 0x00, 0xf0, 0x0f,
  // 0x83, 0x24, 0x80, 0x41, 0x23, 0x2c, 0x80, 0x40, 0x73, 0x24, 0x40, 0xf1,
  // 0x23, 0x20, 0x80, 0x10, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x84, 0x00,
  // 0x63, 0x1a, 0x04, 0x02, 0x73, 0x24, 0x20, 0x7b, 0x73, 0x00, 0x20, 0x7b,
  // 0x73, 0x10, 0x24, 0x7b, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x04, 0x1c,
  // 0x13, 0x04, 0x04, 0xf4, 0x63, 0x16, 0x04, 0x00, 0x23, 0x2c, 0x90, 0x40,
  // 0x67, 0x00, 0x00, 0x40, 0x73, 0x24, 0x40, 0xf1, 0x23, 0x26, 0x80, 0x10,
  // 0x73, 0x60, 0x04, 0x7b, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x04, 0x02,
  // 0xe3, 0x0c, 0x04, 0xfe, 0x6f, 0xf0, 0x1f, 0xfe).map(_.toByte)

  wire [31:0] debug_rom [0:28]; // 29 words in total

  assign rom_dout = debug_rom[rom_addr]; 

  // 0x6f, 0x00, 0xc0, 0x03, 0x6f, 0x00, 0xc0, 0x00, 0x13, 0x04, 0xf0, 0xff,
  assign debug_rom[ 0][7 : 0] = 8'h6f;
  assign debug_rom[ 0][15: 8] = 8'h00;
  assign debug_rom[ 0][23:16] = 8'hc0;
  assign debug_rom[ 0][31:24] = 8'h03;
  
  assign debug_rom[ 1][7 : 0] = 8'h6f;
  assign debug_rom[ 1][15: 8] = 8'h00;
  assign debug_rom[ 1][23:16] = 8'hc0;
  assign debug_rom[ 1][31:24] = 8'h00;
 
  assign debug_rom[ 2][7 : 0] = 8'h13;
  assign debug_rom[ 2][15: 8] = 8'h04;
  assign debug_rom[ 2][23:16] = 8'hf0;
  assign debug_rom[ 2][31:24] = 8'hff;

  // 0x6f, 0x00, 0x80, 0x00, 0x13, 0x04, 0x00, 0x00, 0x0f, 0x00, 0xf0, 0x0f,
  assign debug_rom[ 3][7 : 0] = 8'h6f;
  assign debug_rom[ 3][15: 8] = 8'h00;
  assign debug_rom[ 3][23:16] = 8'h80;
  assign debug_rom[ 3][31:24] = 8'h00;

  assign debug_rom[ 4][7 : 0] = 8'h13;
  assign debug_rom[ 4][15: 8] = 8'h04;
  assign debug_rom[ 4][23:16] = 8'h00;
  assign debug_rom[ 4][31:24] = 8'h00;

  assign debug_rom[ 5][7 : 0] = 8'h0f;
  assign debug_rom[ 5][15: 8] = 8'h00;
  assign debug_rom[ 5][23:16] = 8'hf0;
  assign debug_rom[ 5][31:24] = 8'h0f;

  // 0x83, 0x24, 0x80, 0x41, 0x23, 0x2c, 0x80, 0x40, 0x73, 0x24, 0x40, 0xf1,
  assign debug_rom[ 6][7 : 0] = 8'h83;
  assign debug_rom[ 6][15: 8] = 8'h24;
  assign debug_rom[ 6][23:16] = 8'h80;
  assign debug_rom[ 6][31:24] = 8'h41;
 
  assign debug_rom[ 7][7 : 0] = 8'h23;
  assign debug_rom[ 7][15: 8] = 8'h2c;
  assign debug_rom[ 7][23:16] = 8'h80;
  assign debug_rom[ 7][31:24] = 8'h40;

  assign debug_rom[ 8][7 : 0] = 8'h73;
  assign debug_rom[ 8][15: 8] = 8'h24;
  assign debug_rom[ 8][23:16] = 8'h40;
  assign debug_rom[ 8][31:24] = 8'hf1;

  // 0x23, 0x20, 0x80, 0x10, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x84, 0x00,
  assign debug_rom[ 9][7 : 0] = 8'h23;
  assign debug_rom[ 9][15: 8] = 8'h20;
  assign debug_rom[ 9][23:16] = 8'h80;
  assign debug_rom[ 9][31:24] = 8'h10;

  assign debug_rom[10][7 : 0] = 8'h73;
  assign debug_rom[10][15: 8] = 8'h24;
  assign debug_rom[10][23:16] = 8'h00;
  assign debug_rom[10][31:24] = 8'h7b;
                   
  assign debug_rom[11][7 : 0] = 8'h13;
  assign debug_rom[11][15: 8] = 8'h74;
  assign debug_rom[11][23:16] = 8'h84;
  assign debug_rom[11][31:24] = 8'h00;
                  
  // 0x63, 0x1a, 0x04, 0x02, 0x73, 0x24, 0x20, 0x7b, 0x73, 0x00, 0x20, 0x7b,
  assign debug_rom[12][7 : 0] = 8'h63;
  assign debug_rom[12][15: 8] = 8'h1a;
  assign debug_rom[12][23:16] = 8'h04;
  assign debug_rom[12][31:24] = 8'h02;
                 
  assign debug_rom[13][7 : 0] = 8'h73;
  assign debug_rom[13][15: 8] = 8'h24;
  assign debug_rom[13][23:16] = 8'h20;
  assign debug_rom[13][31:24] = 8'h7b;
                
  assign debug_rom[14][7 : 0] = 8'h73;
  assign debug_rom[14][15: 8] = 8'h00;
  assign debug_rom[14][23:16] = 8'h20;
  assign debug_rom[14][31:24] = 8'h7b;
               
  // 0x73, 0x10, 0x24, 0x7b, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x04, 0x1c,
  assign debug_rom[15][7 : 0] = 8'h73;
  assign debug_rom[15][15: 8] = 8'h10;
  assign debug_rom[15][23:16] = 8'h24;
  assign debug_rom[15][31:24] = 8'h7b;
              
  assign debug_rom[16][7 : 0] = 8'h73;
  assign debug_rom[16][15: 8] = 8'h24;
  assign debug_rom[16][23:16] = 8'h00;
  assign debug_rom[16][31:24] = 8'h7b;
             
  assign debug_rom[17][7 : 0] = 8'h13;
  assign debug_rom[17][15: 8] = 8'h74;
  assign debug_rom[17][23:16] = 8'h04;
  assign debug_rom[17][31:24] = 8'h1c;
            
  // 0x13, 0x04, 0x04, 0xf4, 0x63, 0x16, 0x04, 0x00, 0x23, 0x2c, 0x90, 0x40,
  assign debug_rom[18][7 : 0] = 8'h13;
  assign debug_rom[18][15: 8] = 8'h04;
  assign debug_rom[18][23:16] = 8'h04;
  assign debug_rom[18][31:24] = 8'hf4;
           
  assign debug_rom[19][7 : 0] = 8'h63;
  assign debug_rom[19][15: 8] = 8'h16;
  assign debug_rom[19][23:16] = 8'h04;
  assign debug_rom[19][31:24] = 8'h00;

  assign debug_rom[20][7 : 0] = 8'h23;
  assign debug_rom[20][15: 8] = 8'h2c;
  assign debug_rom[20][23:16] = 8'h90;
  assign debug_rom[20][31:24] = 8'h40;
                   
  // 0x67, 0x00, 0x00, 0x40, 0x73, 0x24, 0x40, 0xf1, 0x23, 0x26, 0x80, 0x10,
  assign debug_rom[21][7 : 0] = 8'h67;
  assign debug_rom[21][15: 8] = 8'h00;
  assign debug_rom[21][23:16] = 8'h00;
  assign debug_rom[21][31:24] = 8'h40;
                  
  assign debug_rom[22][7 : 0] = 8'h73;
  assign debug_rom[22][15: 8] = 8'h24;
  assign debug_rom[22][23:16] = 8'h40;
  assign debug_rom[22][31:24] = 8'hf1;
                 
  assign debug_rom[23][7 : 0] = 8'h23;
  assign debug_rom[23][15: 8] = 8'h26;
  assign debug_rom[23][23:16] = 8'h80;
  assign debug_rom[23][31:24] = 8'h10;
                
  // 0x73, 0x60, 0x04, 0x7b, 0x73, 0x24, 0x00, 0x7b, 0x13, 0x74, 0x04, 0x02,
  assign debug_rom[24][7 : 0] = 8'h73;
  assign debug_rom[24][15: 8] = 8'h60;
  assign debug_rom[24][23:16] = 8'h04;
  assign debug_rom[24][31:24] = 8'h7b;
               
  assign debug_rom[25][7 : 0] = 8'h73;
  assign debug_rom[25][15: 8] = 8'h24;
  assign debug_rom[25][23:16] = 8'h00;
  assign debug_rom[25][31:24] = 8'h7b;
              
  assign debug_rom[26][7 : 0] = 8'h13;
  assign debug_rom[26][15: 8] = 8'h74;
  assign debug_rom[26][23:16] = 8'h04;
  assign debug_rom[26][31:24] = 8'h02;
             
  // 0xe3, 0x0c, 0x04, 0xfe, 0x6f, 0xf0, 0x1f, 0xfe).map(_.toByte)
  assign debug_rom[27][7 : 0] = 8'he3;
  assign debug_rom[27][15: 8] = 8'h0c;
  assign debug_rom[27][23:16] = 8'h04;
  assign debug_rom[27][31:24] = 8'hfe;
            
  assign debug_rom[28][7 : 0] = 8'h6f;
  assign debug_rom[28][15: 8] = 8'hf0;
  assign debug_rom[28][23:16] = 8'h1f;
  assign debug_rom[28][31:24] = 8'hfe;

endmodule

