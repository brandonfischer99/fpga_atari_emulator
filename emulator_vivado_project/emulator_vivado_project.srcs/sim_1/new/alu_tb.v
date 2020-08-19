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

task checkAnd;
    input [7:0] testA;
    input [7:0] testB;
    static reg [7:0] tmp = testA & testB;
    
    static bit [7:0] OPS [0:7] = {8'h29, 8'h25, 8'h35, 8'h2d, 8'h3d, 8'h39, 8'h21, 8'h31};
    
    begin
        $display("Testing AND\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( out == (testA & testB)) else $fatal(1, "Bad AND\n");
            assert( NegativeFlag == tmp[7]) else $fatal(1, "Bad Negative Flag\n");
            assert( ZeroFlag == (tmp == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
        end
    end

endtask

task checkALS;
    input [7:0] testA;
    static reg [9:0] tmp = {1'b0,testA};
    
    static bit [7:0] OPS [0:4] = {8'h0a, 8'h06, 8'h16, 8'h0e, 8'h1e};
    
    begin
        tmp = tmp << 1;
        $display("Testing ALS\n");
        for(integer i = 0; i < 5; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == tmp[7:0]) else $fatal(1, "Bad ALS\n");
            assert( NegativeFlag == tmp[7]) else $fatal(1, "Bad Negative Flag\n");
            assert( ZeroFlag == (tmp[7:0] == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( CarryOut == tmp[8]) else $fatal(1, "Bad Carryout\n");
        end
    end
    
endtask

task checkBitsOp;
    input [7:0] testA;
    input [7:0] testB;
    static reg [7:0] tmp = testA & testB;
    
    static bit [7:0] OPS [0:2] = {8'h2c, 8'h89, 8'h24};
    
    begin
        $display("Testing ALS\n");
        for(integer i = 0; i < 3; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( ZeroFlag == (tmp == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == B[7]) else $fatal(1, "Bad Negative Flag\n");
            assert( Overflow == B[6]) else $fatal(1, "Bad Overflow Flag\n");
        end
    end
        
endtask

initial begin
    //task calls to check add with carry
    checkAdd(8'h1,8'h1);
    
    checkAdd(8'h0, 8'h0);
    
    checkAdd(8'hff,8'hff);
    
    checkAdd(8'h80, 8'h80);
    
    //task calls to check Bitwise AND, not including test bits operation (A & M)
    checkAnd(8'h00, 8'h00);
    
    checkAnd(8'hff, 8'hff);
    
    checkAnd(8'h41, 8'h41);
    
    //task calls to check one bit ALS
    checkALS(8'h80);
    
    checkALS(8'h70);
    
    //task calls to check test bits
    checkBitsOp(8'hff, 8'h80);
    
    checkBitsOp(8'hff, 8'h70);
    
    $display("@@@Passed\n");
    $finish;
    
end

endmodule
