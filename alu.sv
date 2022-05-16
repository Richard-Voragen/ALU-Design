module alu(input logic [31:0] a, b, 
    input logic [1:0] ALUControl,
    output logic [31:0] Result,
    output logic [3:0] ALUFlags);
      
      
logic[31:0] Cout;
logic[31:0] res;
reg [31:0] results;
reg [3:0] cin;
reg [31:0] altB;

always_comb begin
  for (int i = 0; i < 32; i=i+1) altB[i] = b[i] ^ ALUControl[0];
end

EightBitAdder bits0_7(.A(a[7:0]), .B(altB[7:0]), .Cin(ALUControl[0]), .S(res[7:0]), .Cout(Cout[7:0]));
EightBitAdder bits8_15(.A(a[15:8]), .B(altB[15:8]), .Cin(Cout[7]), .S(res[15:8]), .Cout(Cout[15:8]));
EightBitAdder bits16_23(.A(a[23:16]), .B(altB[23:16]), .Cin(Cout[15]), .S(res[23:16]), .Cout(Cout[23:16]));
EightBitAdder bits24_31(.A(a[31:24]), .B(altB[31:24]), .Cin(Cout[23]), .S(res[31:24]), .Cout(Cout[31:24]));

always_comb begin
  for (integer i = 0; i < 4; i=i+1) begin
    {cin[i]} = 0;
  end
  results = res;
  
    cin[2] = 1;
     for (integer i = 0; i < 32; i=i+1) begin
  	     if (b[i] == 1) cin[2] = 0;
  	  end
  	  if (cin[2] == 1 && ALUControl[0] == 1 && ALUControl[1] == 0) cin[1] = 1;
  	    
  if (ALUControl[1] == 0) begin
    if (Cout[31] ^ Cout[30] == 1) begin
      {cin[0]} = 1;
    end
    if (cin[1] == 0) cin[1] = Cout[31];
  end
  if (ALUControl[1] == 1) begin
    if (ALUControl[0] == 0) begin
  	   results = a & b;
    end
    if (ALUControl[0] == 1) begin
     	results = a | b;
    end
  end
  cin[2] = 1;
  for (integer i = 0; i < 32; i=i+1) begin
    if (results[i] == 1) cin[2] = 0;
  end
  if (results[31] == 1) begin
    cin[3] = 1;
  end
end

assign ALUFlags = cin;
assign Result = results;

endmodule


module EightBitAdder(
    input logic [7:0] A,
    input logic [7:0] B,
    input logic Cin,
    output logic [7:0] S,
    output logic [7:0] Cout
);

OneBitAdder bit0(.A(A[0]), .B(B[0]), .Cin(Cin), .S(S[0]), .Cout(Cout[0]));
OneBitAdder bit1(.A(A[1]), .B(B[1]), .Cin(Cout[0]), .S(S[1]), .Cout(Cout[1]));
OneBitAdder bit2(.A(A[2]), .B(B[2]), .Cin(Cout[1]), .S(S[2]), .Cout(Cout[2]));
OneBitAdder bit3(.A(A[3]), .B(B[3]), .Cin(Cout[2]), .S(S[3]), .Cout(Cout[3]));
OneBitAdder bit4(.A(A[4]), .B(B[4]), .Cin(Cout[3]), .S(S[4]), .Cout(Cout[4]));
OneBitAdder bit5(.A(A[5]), .B(B[5]), .Cin(Cout[4]), .S(S[5]), .Cout(Cout[5]));
OneBitAdder bit6(.A(A[6]), .B(B[6]), .Cin(Cout[5]), .S(S[6]), .Cout(Cout[6]));
OneBitAdder bit7(.A(A[7]), .B(B[7]), .Cin(Cout[6]), .S(S[7]), .Cout(Cout[7]));

endmodule


module OneBitAdder(
  input logic A,
  input logic B,
  input logic Cin,
  output logic S,
  output logic Cout);
  
logic	WIRE_1;
logic	WIRE_2;
logic	WIRE_3;
  
assign WIRE_1 = A ^ B;
assign S = WIRE_1 ^ Cin;
assign WIRE_2 = WIRE_1 & Cin;
assign WIRE_3 = A & B;
assign Cout = WIRE_2 | WIRE_3;

endmodule
