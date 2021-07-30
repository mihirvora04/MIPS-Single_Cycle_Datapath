module InstMem(clock, address, inst);

	input clock;
	input [31:0] address;
	
	output reg [31:0]	inst;
	
	reg [31:0] Mem [0:127];
	
	initial begin
		Mem[0] = 32'h00221820; //add: R3, R1, R2
		Mem[1] = 32'hAC010000; //sw: R1, 0(R0)
		Mem[2] = 32'h8C240000; //lw R4, 0(R1)
		Mem[3] = 32'h10210001; //beq R1, R1, 1
		Mem[4] = 32'h00001820; //add R3, R0, R0
		Mem[5] = 32'h00e84828; //floating point addition R9,R7,R8
	end
	
	always @( posedge clock) begin
		inst <= Mem[address[31:2]];
	end
endmodule
