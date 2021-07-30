module ALU (ALUCtl, A, B, fpa_sum, ALUOut, Zero);

	input [3:0] ALUCtl;
	input [31:0] A,B;
   input [31:0] fpa_sum;	
	output reg [31:0] ALUOut;
	output Zero;
	assign Zero = (ALUOut == 0);
	
	
	always @(ALUCtl, A, B)
	begin
		case (ALUCtl)
			0: ALUOut <= A & B;
			1: ALUOut <= A | B;
			2: ALUOut <= A + B;
			6: ALUOut <= A - B;
			7: ALUOut <= A < B ? 1:0;
			5:ALUOut <= fpa_sum;
			12:ALUOut <= ~(A | B);
			default: ALUOut <= 0;
		endcase
	end
endmodule


