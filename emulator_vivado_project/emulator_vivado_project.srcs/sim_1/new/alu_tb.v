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

task checkAdd(
    input [7:0] A, input [7:0] B
    );
    static bit [7:0] OPS [0:7] = {8'h69, 8'h65, 8'h75, 8'h6d, 8'h7d, 8'h79, 8'h61, 8'h71};
    begin
        $display("Testing Add\n");
        
    end
endtask

initial begin
    A = 8'h0;
    B = 8'h0;
    CarryIn = 0;
    #100;//hold reset
    
    
    
end

endmodule
