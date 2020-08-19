`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Coded by Brandon Fischer
// Adapted from https://www.fpga4student.com/2017/06/Verilog-code-for-ALU.html
// Codes/ALU design from MCS6500 programming manual
// 
// Create Date: 08/13/2020 03:43:44 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_tb;

//Inputs
reg[7:0] A,B;
reg[7:0] OP;
reg CarryIn;

//outputs
wire [7:0] out;
wire CarryOut;
wire ZeroFlag;
wire Overflow;
wire NegativeFlag;

alu test_unit(
    A,B,OP,CarryIn,
    out,CarryOut,ZeroFlag,Overflow,NegativeFlag
);

task checkAdd;
    input [7:0] testA;
    input [7:0] testB;
    static reg [9:0] tmp = {1'b0,testA} + {1'b0,testB};
    
    static bit [7:0] OPS [0:7] = {8'h69, 8'h65, 8'h75, 8'h6d, 8'h7d, 8'h79, 8'h61, 8'h71};
    begin
        $display("Testing Add\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( out == (testA + testB)) else $fatal(1, "Bad add\n");
            assert( CarryOut == tmp[8]) else $fatal(1, "Bad Carryout\n");
            assert( ZeroFlag == (tmp[7:0] == 8'h00)) else $fatal(1, "Bad Zero flag\n");
            assert( Overflow == (CarryOut ^ tmp[7])) else $fatal(1, "Bad Overflow Flag\n");
            assert( NegativeFlag == tmp[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
endtask

initial begin

    checkAdd(8'h1,8'h1);
    
    checkAdd(8'h0, 8'h0);
    
    checkAdd(8'hff,8'hff);
    
    checkAdd(8'h80, 8'h80);
    
    $display("@@@Passed\n");
    $finish;
    
end

endmodule
