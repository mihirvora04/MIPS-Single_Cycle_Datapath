`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:47 02/21/2021 
// Design Name: 
// Module Name:    fpa 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fpa( a_original, b_original, sum
    );
	 
	input [31:0] a_original, b_original;
   output reg [31:0] sum ;	
	reg [31:0] a,b ;
   reg [25:0] a_significand, b_significand, sum_significand; 
	reg [22:0] a_fraction, b_fraction;
   reg [7:0]  a_exp, b_exp, sum_exp;
   reg        a_sign, b_sign, sum_sign;
   reg [7:0]  exp_diff;

   always @( a_original or b_original )
	begin


        /// Adjusting a&b such that the number with the smaller exponent is b.
		  
        if ( a_original[30:23] < b_original[30:23] ) 
		  begin

           a = b_original;  b = a_original;

        end 
		  else begin

           a = a_original;  b = b_original;

        end

        // Break operand into sign , exponent, and significand.
		  
        a_sign = a[31]; b_sign = b[31];
        a_exp = a[30:23]; b_exp = b[30:23];
		  a_fraction = a[22:0]; b_fraction = b[22:0];
		  
		  // 2 additional 0's are added which will later be used for checking sign and overflow
		  a_significand = { 2'b0, 1'b1 , a[22:0] };
        b_significand = { 2'b0, 1'b1 , b[22:0] };

        // calculating difference between the smaller and larger exponent
		  
        exp_diff = a_exp - b_exp;
		  
		  // Adjusting the significand part of b according to the difference in exponents.
        
		  b_significand = b_significand >> exp_diff;
		  
		  // Giving proper sign to the significand
		  if ( a_sign ) a_significand = -a_significand;
        if ( b_sign ) b_significand = -b_significand;

		  //Doing sum
		  sum_significand = a_significand + b_significand;
		  
		  //Start Normalizing:
		  //First take the modular value of the significand
		  sum_sign = sum_significand[25];
        if ( sum_sign ) sum_significand = -sum_significand;

        //Check if the significand has to be shifted right
        if ( sum_significand[24] ) 
		  begin
           // Sum overflow; Right shift significand and increment exponent.

           sum_exp = a_exp + 1;
			  sum_significand = sum_significand >> 1;

			   if (sum_exp == 255)
				// The sum will be represented as +-infinity.
			   begin
			   sum_significand=0;
			   end
           
        end
		  else if (sum_significand) begin:A 
		    // Sum did not overflow and is not equal to zero; so find the first non-zero.
			  integer pos, adj, i;
           pos = 0;
           for (i = 23; i >= 0; i = i - 1 ) if ( !pos && sum_significand[i] ) pos = i;

           // Compute amount to shift significand and reduce exponent.
           adj = 23 - pos;
           if ( a_exp < adj ) begin
             // Exponent too small, floating point underflow, set to zero.

              sum_exp = 0;
              sum_significand = 0;

           end 
			  else begin
           // Adjust significand and exponent.

              sum_exp = a_exp - adj;
              sum_significand = sum_significand << adj;

           end

        end 
		  else begin
           // Sum is zero.

           sum_exp = 0;
           sum_significand = 0;

        end
			sum[31] = sum_sign;
         sum[30:23] = sum_exp;
         sum[22:0] = sum_significand[22:0];			
		  
		  
	end
endmodule
