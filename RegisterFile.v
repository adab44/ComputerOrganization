`timescale 1ns / 1ps

module RegisterFile(I, OutASel , OutBSel , Clock, FunSel , RegSel , ScrSel , OutA ,OutB);
        input wire Clock;
        input wire [15:0] I;
        input wire [2:0] OutASel;
        input wire  [2:0] OutBSel;
        input wire [3:0] RegSel;
        input wire [3:0] ScrSel;
        input wire [2:0] FunSel;
        output wire [15:0] OutA;
        output wire [15:0] OutB;
        reg[15:0] TempA =0;
        reg[15:0] TempB =0;

        wire [15:0] R1_Q, R2_Q, R3_Q, R4_Q, S1_Q, S2_Q, S3_Q, S4_Q;
        
        Register  R4(.Clock(Clock), .E(~RegSel[0]), .FunSel(FunSel), .I(I), .Q(R4_Q));
        Register  R3(.Clock(Clock), .E(~RegSel[1]), .FunSel(FunSel), .I(I), .Q(R3_Q));
        Register  R2(.Clock(Clock), .E(~RegSel[2]), .FunSel(FunSel), .I(I), .Q(R2_Q));
        Register  R1(.Clock(Clock), .E(~RegSel[3]), .FunSel(FunSel), .I(I), .Q(R1_Q));
        Register  S4(.Clock(Clock), .E(~ScrSel[0]), .FunSel(FunSel), .I(I), .Q(S4_Q));
        Register  S3(.Clock(Clock), .E(~ScrSel[1]), .FunSel(FunSel), .I(I), .Q(S3_Q));
        Register  S2(.Clock(Clock), .E(~ScrSel[2]), .FunSel(FunSel), .I(I), .Q(S2_Q));
        Register  S1(.Clock(Clock), .E(~ScrSel[3]), .FunSel(FunSel), .I(I), .Q(S1_Q));
        
        
        
        always @ (*) begin
        case (OutASel)
        3'b000: TempA = R1_Q;
        3'b001: TempA = R2_Q;
        3'b010: TempA = R3_Q;
        3'b011: TempA = R4_Q;
        3'b100: TempA = S1_Q;
        3'b101: TempA = S2_Q;
        3'b110: TempA = S3_Q;
        3'b111: TempA = S4_Q;
        endcase
        case (OutBSel)
        3'b000: TempB = R1_Q;
        3'b001: TempB = R2_Q;
        3'b010: TempB = R3_Q;
        3'b011: TempB = R4_Q;
        3'b100: TempB = S1_Q;
        3'b101: TempB = S2_Q;
        3'b110: TempB = S3_Q;
        3'b111: TempB = S4_Q;
        endcase
    end
    assign OutA = TempA;
    assign OutB = TempB;
endmodule


