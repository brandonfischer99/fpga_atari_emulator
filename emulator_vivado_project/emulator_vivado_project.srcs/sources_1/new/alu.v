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
        output [7:0] out,
        output CarryOut,
        output ZeroFlag,
        output Overflow,
        output NegativeFlag
    );
    
    reg [7:0] result;
    wire [8:0] tmp;
    reg Overflow_reg;
    wire overflowAdd = ~A[7] & ~B[7] & result[7] | A[7] & B[7] & ~result[7];
    wire overflowSubtract = ~A[7] & B[7] & result[7] | A[7] & ~B[7] & ~result[7];
    
    assign out = result;
    assign tmp = {1'b0,A} + {1'b0,B};
    assign CarryOut = tmp[8];
    assign ZeroFlag = (result==8'd0)?1'd1:1'd0;
    assign Overflow = Overflow_reg;
    assign NegativeFlag = result[7];
    
    //Coding the OP codes in order of appearance in the manual
    always@(*)
    begin
        case(OP)
            //Section 1: ADC-Add memory to accumulator with carry
            8'h69, 8'h65, 8'h75, 8'h6d, 8'h7d, 8'h79, 8'h61, 8'h71:
            begin
                result = A + B;
                Overflow_reg = overflowAdd;
            end
            //Section 2: "AND" memory with accumulator
            8'h29, 8'h25, 8'h35, 8'h2d, 8'h3d, 8'h39, 8'h21, 8'h31:
                result = A & B;
            //Section 3: Shift Left One Bit (Memory or Accumulator)
            8'h0a, 8'h06, 8'h16, 8'h0e, 8'h1e:
                result = A << 1;
            //Section 4: 
            
            default: result = A + B;
        endcase
    end
    
endmodule
