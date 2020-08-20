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


module alu(
        input [7:0] A,B,
        input [7:0] OP,
        input CarryIn,
        output [7:0] out,
        output CarryOut,
        output ZeroFlag,
        output Overflow,
        output NegativeFlag
    );
    
    reg [7:0] result;
    wire [8:0] tmp;
    reg CarryOut_reg;
    reg Overflow_reg;
    reg NegativeFlag_reg;
    wire overflowAdd = ~A[7] & ~B[7] & result[7] | A[7] & B[7] & ~result[7];
    wire overflowSubtract = ~A[7] & B[7] & result[7] | A[7] & ~B[7] & ~result[7];
    //wire overflowSubtract = (~A[7] & ~B[7]) | (~A[7] & B[7] & ~result[7]) | (A[7] & ~B[7] & result[7]) | (A[7] & B[7]);
    
    assign out = result;
    assign tmp = {1'b0,A} + {1'b0,B} + {8'b0,CarryIn};
    assign CarryOut = CarryOut_reg;
    assign ZeroFlag = (result==8'd0)?1'd1:1'd0;
    assign Overflow = Overflow_reg;
    assign NegativeFlag = NegativeFlag_reg;
    
    //Coding the arithmetic OP codes per https://en.wikibooks.org/wiki/6502_Assembly
    //Done in order found in the manual
    always@(*)
    begin
        case(OP)
            //Adding with Carry
            8'h69, 8'h65, 8'h75, 8'h6d, 8'h7d, 8'h79, 8'h61, 8'h71:
            begin
                result = A + B + CarryIn;
                Overflow_reg = overflowAdd;
                NegativeFlag_reg = result[7];
                CarryOut_reg = tmp[8];
            end
            //Bitwise AND, not including test bits operation (A & M)
            8'h29, 8'h25, 8'h35, 8'h2d, 8'h3d, 8'h39, 8'h21, 8'h31:
            begin
                result = A & B;
                NegativeFlag_reg = result[7];
            end
            //Test bits operation ( A & M )
            8'h2c, 8'h89, 8'h24:
            begin
                result = A & B;
                NegativeFlag_reg = B[7];
                Overflow_reg = B[6];
            end
            //One bit left shift
            8'h0a, 8'h06, 8'h16, 8'h0e, 8'h1e:
            begin
                CarryOut_reg = A[7];
                result = A << 1;
                NegativeFlag_reg = result[7];
            end
            //Compare memory and accumulator A - M, memory and index X ( X - M ),
            //and memory and index Y ( Y - M )
            8'hc9, 8'hc5, 8'hd5, 8'hcd, 8'hdd, 8'hd9, 8'hc1, 8'hd1, 8'he0, 8'he4, 8'hec,
                8'hc0, 8'hc4, 8'hcc:
            begin
                result = A - B;
                NegativeFlag_reg = result[7];
                CarryOut_reg = (~NegativeFlag_reg & ~ZeroFlag) | (~NegativeFlag_reg & ZeroFlag);
            end
            //Decrement memory, index X, and index Y by 1
            8'hc6, 8'hd6, 8'hce, 8'hde, 8'hca, 8'h88:
            begin
                result = A - 1;
                NegativeFlag_reg = result[7];
            end
            //XOR memory with accumulator
            8'h49, 8'h45, 8'h55, 8'h4d, 8'h5d, 8'h59, 8'h41, 8'h51:
            begin
                result = A ^ B;
                NegativeFlag_reg = result[7];
            end
            //Increment memory, index X, and index Y by 1
            8'he6, 8'hf6, 8'hee, 8'hfe, 8'he8, 8'hc8:
            begin
                result = A + 1;
                NegativeFlag_reg = result[7];
            end
            //Logical right shift
            8'h4a, 8'h46, 8'h56, 8'h4e, 8'h5e:
            begin
                result = A >> 1;
                CarryOut_reg = A[0];
                NegativeFlag_reg = 0;
            end
            //OR memory with accumulator
            8'h08, 8'h05, 8'h15, 8'h0d, 8'h1d, 8'h19, 8'h01, 8'h11:
            begin
                result = A | B;
                NegativeFlag_reg = result[7];
            end
            //Rotate one bit left
            8'h2a, 8'h26, 8'h36, 8'h2e, 8'h3e:
            begin
                result = {A[6:0],A[7]};
                CarryOut_reg = A[7];
                NegativeFlag_reg = result[7];
            end
            //Rotate one bit right
            8'h6a, 8'h66, 8'h76, 8'h6e, 8'h7e:
            begin
                result = {A[0],A[7:1]};
                CarryOut_reg = A[0];
                NegativeFlag_reg = result[7];
            end
            //Subtract memory from accumulator with borrow
            8'he9, 8'he5, 8'hf5, 8'hed, 8'hfd, 8'hf9, 8'he1, 8'hf1:
            begin
                result = A - B - {7'b0,~CarryIn};
                CarryOut_reg = (result>=8'd0)?1'd1:1'd0;
                Overflow_reg = overflowSubtract;
                NegativeFlag_reg = result[7];
            end
            
            default: 
            begin
                result = result;
                CarryOut_reg = 0;
                Overflow_reg = 0;
                NegativeFlag_reg = 0;
            end
        endcase
    end
    
endmodule
