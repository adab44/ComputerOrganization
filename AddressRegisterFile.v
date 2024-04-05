`timescale 1ns / 1ps



module AddressRegisterFile(Clock,I, OutCSel , OutDSel , FunSel , RegSel , OutC , OutD );

    input wire Clock;
    input wire [15:0] I;
    input wire[1:0] OutCSel;
    input wire[1:0] OutDSel;
    input wire[2:0] FunSel;
    input wire[2:0] RegSel;
    output reg [15:0] OutC;
    output reg [15:0] OutD;

    wire PC_enable, AR_enable, SP_enable;

    // Decode RegSel to enable signals for each register
    assign PC_enable = (RegSel == 3'b000) || (RegSel == 3'b001) || (RegSel == 3'b010) || (RegSel == 3'b011);
    assign AR_enable = (RegSel == 3'b000) || (RegSel == 3'b001) || (RegSel == 3'b100) || (RegSel == 3'b101);
    assign SP_enable = (RegSel == 3'b000) || (RegSel == 3'b010) || (RegSel == 3'b100) || (RegSel == 3'b110);

    Register  PC (.Clock(Clock), .E(PC_enable), .FunSel(FunSel), .I(I), .Q());
    Register  AR (.Clock(Clock), .E(AR_enable), .FunSel(FunSel), .I(I), .Q());
    Register  SP (.Clock(Clock), .E(SP_enable), .FunSel(FunSel), .I(I), .Q());
    
     always @(*) begin
        case (OutCSel)
            2'b00: OutC = PC.Q;
            2'b01: OutC = PC.Q; 
            2'b10: OutC = AR.Q;
            2'b11: OutC = SP.Q;
        endcase
    end

    always @(*) begin
        case (OutDSel)
            2'b00: OutD = PC.Q;
            2'b01: OutD = PC.Q;
            2'b10: OutD = AR.Q;
            2'b11: OutD = SP.Q;
        endcase
    end
endmodule

