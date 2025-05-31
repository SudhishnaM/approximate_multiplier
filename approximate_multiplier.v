// Half Adder Module
`timescale 1ns / 1ps

module half_adder(input x, input y, output sum, output carry);
    assign sum = x ^ y;
    assign carry = x & y;
endmodule

module full_adder(input x, input y, input z, output sum, output carry);
    assign sum = x ^ y ^ z;
    assign carry = y;
endmodule

module compressor(input i1, input i2, input i3, input i4, output out1, output out2);
    assign out1 = (i1 | i2) ^ (i3 | i4);
    assign out2 = (i1 | i2) & (i3 | i4);
endmodule

module approximate_multiplier(
    input [3:0] A, B,
    output [7:0] P
);

// Partial products
assign pp0  = A[0] & B[0];
assign pp1  = A[1] & B[0];
assign pp2  = A[2] & B[0];
assign pp3  = A[3] & B[0];
assign pp4  = A[0] & B[1];
assign pp5  = A[1] & B[1];
assign pp6  = A[2] & B[1];
assign pp7  = A[3] & B[1];
assign pp8  = A[0] & B[2];
assign pp9  = A[1] & B[2];
assign pp10 = A[2] & B[2];
assign pp11 = A[3] & B[2];
assign pp12 = A[0] & B[3];
assign pp13 = A[1] & B[3];
assign pp14 = A[2] & B[3];
assign pp15 = A[3] & B[3];

// Pairwise OR/AND approximations
assign s1 = pp1  | pp4;   assign c1 = pp1  & pp4;
assign s2 = pp2  | pp8;   assign c2 = pp2  & pp8;
assign s3 = pp3  | pp12;  assign c3 = pp3  & pp12;
assign s4 = pp9  | pp6;   assign c4 = pp9  & pp6;
assign s5 = pp13 | pp7;   assign c5 = pp13 & pp7;
assign s6 = pp11 | pp14;  assign c6 = pp11 & pp14;

// Assign result[0]
assign P[0] = pp0;

// Internal wires
wire w1, w2, w3, w4, w5, w6, u1, u2, u3, u4;

// Staged adders and compressors
half_adder ha1 (s1, c1, P[1], w1);
compressor  c1_mod (s2, pp5, c2, w1, w2, w3);
compressor  c2_mod (s3, s4, c4, c3, w4, w5);
compressor  c3_mod (s5, pp10, c5, 1'b0, w6, u1);
half_adder ha2 (w2, w3, P[2], u2);
full_adder fa1 (w4, w5, u2, P[3], u3);
full_adder fa2 (w6, u1, u3, P[4], u4);
full_adder fa3 (s6, c6, u4, P[5], u1);
half_adder ha3 (pp15, u1, P[6], P[7]);

endmodule
