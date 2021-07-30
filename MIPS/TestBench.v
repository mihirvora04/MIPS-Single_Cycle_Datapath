module MIPS_test;

	// Inputs
	reg clock;
	reg reset;

	// Outputs
	wire [31:0] PCin;
	wire [31:0] PCout;
	wire [31:0] inst;
	wire [4:0] WriteReg;
	wire [31:0] ReadData1;
	wire [31:0] ReadData2;
	wire [31:0] ALUOut;
	wire [31:0] ReadData;

	// Instantiate the Unit Under Test (UUT)
	MipsCPU uut (
		.clock(clock), 
		.reset(reset), 
		.PCout(PCout), 
		.inst(inst),
		.ReadData1(ReadData1), 
		.ReadData2(ReadData2), 
		.ALUOut(ALUOut), 
		.ReadData(ReadData), 
		.WriteReg(WriteReg)
	);
	initial begin
		// Initialize Inputs
		clock = 1;
		reset = 1;
		#60;
		reset =0;
		clock =0;
		#80;
		clock=1;
		repeat (12)
		#80 clock = !clock; 
		
		

		// Wait 100 ns for global reset to finis
		// Add stimulus here

	end
      
endmodule