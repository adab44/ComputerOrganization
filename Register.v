`timescale 1ns / 1ps



module Register (
  input wire Clock,       
  input wire E,         
  input wire [2:0] FunSel, 
  input wire [15:0] I, 
  output reg [15:0] Q  
);

  always @ (posedge Clock) begin
    if (E) begin
      case (FunSel) 
        3'b000: Q <= Q - 1'b1; // -1        
        3'b001: Q <= Q + 1'b1; // +1
        3'b010: Q <= I; // Load
        3'b011: Q <= 0;//clear
        3'b100: begin
        Q[15:8] <= 0;
        Q[7:0] <= I[7:0];
        end // clear and write low
        3'b101:Q[7:0] <= I[7:0] ; // only write low         
        3'b110: Q[15:8] <= I[7:0] ; //only write high  
        3'b111: begin
        Q[15:8] <= {8{I[7]}};
        Q[7:0] <= I[7:0];
        end //Sign extended , write low 
        default: Q = Q; //retain value
      endcase
    end
  end
endmodule
