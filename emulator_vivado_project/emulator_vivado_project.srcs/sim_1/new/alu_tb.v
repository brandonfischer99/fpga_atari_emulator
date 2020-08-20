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
    input testCin;
    static reg [9:0] tmp = {1'b0,testA} + {1'b0,testB} + {8'b0,testCin};
    
    static bit [7:0] OPS [0:7] = {8'h69, 8'h65, 8'h75, 8'h6d, 8'h7d, 8'h79, 8'h61, 8'h71};
    begin
        $display("Testing Add\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            CarryIn = testCin;
            #5
            assert( out == (testA + testB + testCin)) else $fatal(1, "Bad add\n");
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
        $display("Testing Test Bits\n");
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

task checkCompare;
    input [7:0] testA;
    input [7:0] testB;
    static reg [8:0] tmp = {1'b0,testA} - {1'b0,testB};
    
    static bit [7:0] OPS [0:13] = {8'hc9, 8'hc5, 8'hd5, 8'hcd, 8'hdd, 8'hd9, 8'hc1, 8'hd1, 8'he0, 8'he4, 8'hec,
                8'hc0, 8'hc4, 8'hcc};
                
    begin
        $display("Testing Compare\n");
        for(integer i = 0; i < 14; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( ZeroFlag == (tmp[7:0] == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == tmp[7]) else $fatal(1, "Bad Negative Flag\n");
            assert( CarryOut == ((testA > testB) || (testA == testB))) else $fatal(1, "Bad Overflow Flag\n");
        end
    end
    
endtask

task checkDecrement;
    input [7:0] testA;
    
    static bit [7:0] OPS [0:5] = {8'hc6, 8'hd6, 8'hce, 8'hde, 8'hca, 8'h88};
    
    begin
        $display("Testing Decrement\n");
        for(integer i = 0; i < 6; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == (testA - 8'h01)) else $fatal(1, "Bad Decrement\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == out[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
    
endtask

task checkXOR;
    input [7:0] testA;
    input [7:0] testB;
    
    static bit [7:0] OPS [0:7] = {8'h49, 8'h45, 8'h55, 8'h4d, 8'h5d, 8'h59, 8'h41, 8'h51};
    
    begin
        $display("Testing XOR\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( out == (testA ^ testB)) else $fatal(1, "Bad XOR\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == out[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
    
endtask

task checkIncrement;
    input [7:0] testA;
    
    static bit [7:0] OPS [0:5] = {8'he6, 8'hf6, 8'hee, 8'hfe, 8'he8, 8'hc8};
    
    begin
        $display("Testing Increment\n");
        for(integer i = 0; i < 6; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == (testA + 8'h01)) else $fatal(1, "Bad Increment\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == out[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
    
endtask

task checkRightShift;
    input [7:0] testA;
    
    static bit [7:0] OPS [0:4] = {8'h4a, 8'h46, 8'h56, 8'h4e, 8'h5e};
    
    begin
        $display("Testing Right Shift\n");
        for(integer i = 0; i < 5; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == testA >> 1) else $fatal(1, "Bad Right Shift\n");
            assert( NegativeFlag == 0) else $fatal(1, "Bad Negative Flag\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( CarryOut == testA[0]) else $fatal(1, "Bad Carryout\n");
        end
    end
endtask

task checkOR;
    input [7:0] testA;
    input [7:0] testB;
    
    static bit [7:0] OPS [0:7] = {8'h08, 8'h05, 8'h15, 8'h0d, 8'h1d, 8'h19, 8'h01, 8'h11};
    
    begin
        $display("Testing OR\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            #5
            assert( out == (testA | testB)) else $fatal(1, "Bad OR\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( NegativeFlag == out[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
endtask

task checkRotateLeft;
    input [7:0] testA;
    
    static bit [7:0] OPS [0:4] = {8'h2a, 8'h26, 8'h36, 8'h2e, 8'h3e};
    
    begin
        $display("Testing Rotate Left\n");
        for(integer i = 0; i < 5; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == ({testA[6:0],testA[7]})) else $fatal(1, "Bad Rotate Left\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( CarryOut == testA[7]) else $fatal(1, "Bad CarryOut Flag\n");
        end
    end
    
endtask

task checkRotateRight;
    input [7:0] testA;
    
    static bit [7:0] OPS [0:4] = {8'h6a, 8'h66, 8'h76, 8'h6e, 8'h7e};
    
    begin
        $display("Testing Rotate Right\n");
        for(integer i = 0; i < 5; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            #5
            assert( out == ({testA[0],testA[7:1]})) else $fatal(1, "Bad Rotate Right\n");
            assert( ZeroFlag == (out == 8'h00)) else $fatal(1, "Bad Zero Flag\n");
            assert( CarryOut == testA[0]) else $fatal(1, "Bad CarryOut Flag\n");
        end
    end
    
endtask

task checkSubtract;
    input [7:0] testA;
    input [7:0] testB;
    input testCin;
    static reg [8:0] tmp = {1'b0,testA} - {1'b0,testB} - {8'b0,~testCin};
    static integer test = int'(tmp[7:0]);
    
    static bit [7:0] OPS [0:7] = {8'he9, 8'he5, 8'hf5, 8'hed, 8'hfd, 8'hf9, 8'he1, 8'hf1};
    begin
        $display("Testing Subtract with Borrow\n");
        for(integer i = 0; i < 8; i++)
        begin
            $display("i = %d", i);
            OP = OPS[i];
            A = testA;
            B = testB;
            CarryIn = testCin;
            #5
            assert( out == tmp[7:0]) else $fatal(1, "Bad subtract\n");
            assert( CarryOut == (tmp[7:0] >= 8'h00)) else $fatal(1, "Bad Carryout\n");
            assert( ZeroFlag == (tmp[7:0] == 8'h00)) else $fatal(1, "Bad Zero flag\n");
            assert( Overflow == ((test - 127 > 0) || (test + 127 < 0))) else $fatal(1, "Bad Overflow Flag\n");
            assert( NegativeFlag == tmp[7]) else $fatal(1, "Bad Negative Flag\n");
        end
    end
endtask

initial begin
    //task calls to check add with carry
    checkAdd(8'h1,8'h1, 1'b1);
    
    checkAdd(8'h0, 8'h0, 1'b0);
    
    checkAdd(8'hff,8'hff, 1'b1);
    
    checkAdd(8'h80, 8'h80, 1'b0);
    
    checkAdd(8'h80, 8'h80, 1'b1);
    
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
    
    //task calls to check compare
    checkCompare(8'h00, 8'h01);
    
    checkCompare(8'h01, 8'h01);
    
    checkCompare(8'h01, 8'h00);
    
    //task calls to check decrement by 1
    checkDecrement(8'h01);
    
    checkDecrement(8'h00);
    
    checkDecrement(8'h08);
    
    //task calls to check XOR
    checkXOR(8'hAA, 8'h55);
    
    checkXOR(8'hAA, 8'haa);
    
    //task calls to check increment
    checkIncrement(8'hff);
    
    checkIncrement(8'hfd);
    
    checkIncrement(8'h05);
    
    //task calls to check logical right shift
    checkRightShift(8'hff);
    
    checkRightShift(8'h01);
    
    checkRightShift(8'h02);
    
    //task calls to check OR
    checkOR(8'hff, 8'h00);
    
    checkOR(8'h00, 8'h00);
    
    checkOR(8'h01, 8'h01);
    
    //task calls to check rotate left 1 bit
    checkRotateLeft(8'hfe);
    
    checkRotateLeft(8'h01);
    
    checkRotateLeft(8'h7f);
    
    //task calls to check rotate right 1 bit
    checkRotateRight(8'hfe);
    
    checkRotateRight(8'h01);
    
    checkRotateRight(8'h7f);
    
    //task calls to check subtraction with borrow
    checkSubtract(8'h1, 8'h1, 1'b0);
    
    checkSubtract(8'h1, 8'h1, 1'b1);
    
    checkSubtract(8'h08, 8'h09, 1'b1);
    
    checkSubtract(8'h08, 8'h09, 1'b0);
    
    checkSubtract(8'hf0, 8'hf0, 1'b1);
    
    
    $display("@@@Passed\n");
    $finish;
    
end

endmodule
