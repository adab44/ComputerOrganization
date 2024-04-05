`timescale 1ns / 1ps

module ArithmeticLogicUnit(
    input wire Clock,
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [4:0] FunSel,
    input wire WF,
    output reg [15:0] ALUOut,
    output reg [3:0] FlagsOut // [Z, C, N, O]
);

    reg [16:0] temp; // Extended result for carry-out and overflow handling

    always @(*) begin
            temp = 17'b0; // Reset temp
            case(FunSel)
                // 8-bit and 16-bit operations
                5'b00000, 5'b10000: temp = {8'b0, A[7:0]};
                5'b00001, 5'b10001: temp = {8'b0, B[7:0]};
                5'b00010, 5'b10010: temp = ~A;
                5'b00011, 5'b10011: temp = ~B;
                5'b00100, 5'b10100: temp = A + B;
                5'b00101, 5'b10101: temp = A + B + FlagsOut[2]; // Add with carry
                5'b00110, 5'b10110: temp = A - B;
                5'b00111, 5'b10111: temp = A & B;
                5'b01000, 5'b11000: temp = A | B;
                5'b01001, 5'b11001: temp = A ^ B;
                5'b01010, 5'b11010: temp = ~(A & B);
                5'b01011, 5'b11011: temp = {A, 1'b0}; // LSL
                5'b01100, 5'b11100: temp = {1'b0, A} >> 1; // LSR
                5'b01101, 5'b11101: temp = {A[15], A} >> 1; // ASR
                // CSL and CSR need to handle circular shift logic
                default: temp = 17'bx;
            endcase

            ALUOut = temp[15:0]; // Assign the result to ALUOut
            end
always @(posedge Clock) begin
if (WF) begin
            // Update flags based on the operation
            FlagsOut[3] = (ALUOut == 0); // Z flag
            FlagsOut[2] = temp[16]; // C flag
            FlagsOut[1] = ALUOut[15]; // N flag

            // Overflow flag calculation for add and sub operations
            if (FunSel == 5'b00100 || FunSel == 5'b10100) begin
                FlagsOut[0] = (A[15] == B[15]) && (ALUOut[15] != A[15]); // O flag for addition
            end else if (FunSel == 5'b00110 || FunSel == 5'b10110) begin
                FlagsOut[0] = (A[15] != B[15]) && (ALUOut[15] != A[15]); // O flag for subtraction
            end else begin
                FlagsOut[0] = 0; // O flag reset for other operations
            end
        end
    end
  
endmodule


            