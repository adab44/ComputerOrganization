`timescale 1ns / 1ps


module InstructionRegister (
    input wire Clock,      
    input wire Write,    
    input wire LH,       
    input wire [7:0] I,  
    output reg [15:0] IROut 
);
    always @(posedge Clock) begin
        if (Write) begin
            if (LH) begin
              
                IROut[15:8] <= I;// Load I in the high byte of IR
            end
            else begin
                
                IROut[7:0] <= I;// Load I in the low byte of IR
            end
        end
    end
endmodule