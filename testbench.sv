module testbench();
  logic [31:0] a, b;
  logic [1:0] ALUControl;
  logic [31:0] Result;
  logic [3:0] ALUFlags;
  logic [101:0] testVectors [1000:0];
  
  alu dut (.a(a), .b(b), .ALUControl(ALUControl), .Result(Result), .ALUFlags(ALUFlags));
  
  initial begin
      $readmemh("alu.tv", testVectors);
      
    for (int i = 0; i < 16; i=i+1) begin
      ALUControl = testVectors[i][101:100]; a = testVectors[i][99:68]; b = testVectors[i][67:36]; #100;
      if (Result == testVectors[i][35:4] && ALUFlags == testVectors[i][3:0]);
      else $display("INCORRECT!!!");
    end
  end
endmodule