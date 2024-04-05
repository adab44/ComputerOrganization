`timescale 1ns / 1ps

module Mux1bitC(
    input wire MuxCSel,
    input wire [15:0] ALUOut,
    output reg [7:0] MuxCOut
);
    always @(*) begin
        case(MuxCSel)
            1'b0: MuxCOut = ALUOut[7:0];
            1'b1: MuxCOut = ALUOut[15:8];
            default: MuxCOut = 8'bx;
        endcase
    end
endmodule

module Mux2bit(
    input wire [1:0] Mux2bits,
    input wire [15:0] ALUOut,
    input wire [15:0] OutC,
    input wire [7:0] MemOut,
    input wire [15:0] IROut,
    output reg [15:0] Mux2bitO
);
    always @(*) begin
        case(Mux2bits)
            2'b00: Mux2bitO = ALUOut;
            2'b01: Mux2bitO = OutC; 
            2'b10: Mux2bitO = {8'b0, MemOut}; 
            2'b11: Mux2bitO = {8'b0, IROut[7:0]}; 
            default: Mux2bitO = 16'bx; 
        endcase
    end
endmodule

module ArithmeticLogicUnitSystem(
   
    input wire [1:0] ARF_OutCSel, 
    input wire [1:0] ARF_OutDSel, 
    input wire [2:0] ARF_FunSel,
    input wire [4:0] ALU_FunSel,
    input wire ALU_WF,
    input wire [2:0] ARF_RegSel,
    input wire IR_LH,
    input wire IR_Write,
    input wire Mem_WR,
    input wire Mem_CS,
    input wire [1:0] MuxASel,
    input wire [1:0] MuxBSel,
    input wire MuxCSel,
    input wire [2:0] RF_OutASel, 
    input wire [2:0] RF_OutBSel, 
    input wire [2:0] RF_FunSel,
    input wire [3:0] RF_RegSel,
    input wire [3:0] RF_ScrSel,
    input wire Clock
    
);
wire [15:0] IROut;
wire [3:0] FlagsOut;
wire [15:0] MuxAOut, MuxBOut;
wire [7:0] MemOut, MuxCOut;
wire [15:0] ALUOut;
wire [15:0] Address,OutA, OutB, OutC,OutD; 
  
Memory MEM(.Clock(Clock),.Address(Address),.Data(MuxCOut), .WR(Mem_WR),.CS(Mem_CS), .MemOut(MemOut)
        
);
     
ArithmeticLogicUnit ALU(.Clock(Clock),.A(OutA),.B(OutB),.FunSel(ALU_FunSel),.ALUOut(ALUOut),.FlagsOut(FlagsOut),.WF(ALU_WF)
   
 );
    
    Mux2bit MUXA(
         .Mux2bits(MuxASel),
         .ALUOut(ALUOut),
         .OutC(OutC),
         .MemOut(MemOut),
         .IROut(IROut),
         .Mux2bitO(MuxAOut)
     );
    
    Mux2bit MUXB(
             .Mux2bits(MuxBSel),
             .ALUOut(ALUOut),
             .OutC(OutC),
             .MemOut(MemOut),
             .IROut(IROut),
             .Mux2bitO(MuxBOut)
         );
    
    Mux1bitC MUXC(
                 .MuxCSel(MuxCSel),
                 .ALUOut(ALUOut),
                 .MuxCOut(MuxCOut)
             );    
    
    InstructionRegister IR(.Clock(Clock),.I(MemOut),.Write(IR_Write),.LH(IR_LH),.IROut(IROut)
    
    
    );
    
    RegisterFile RF(.Clock(Clock),.I(MuxAOut),.OutASel(RF_OutASel),.OutBSel(RF_OutBSel),.RegSel(RF_RegSel),.ScrSel(RF_ScrSel),.FunSel(RF_FunSel),.OutA(OutA),.OutB(OutB)
    
    
    
    );
    
    AddressRegisterFile ARF(.Clock(Clock),.I(MuxBOut),.OutCSel(ARF_OutCSel),.OutDSel(ARF_OutDSel),.FunSel(ARF_FunSel),.RegSel(ARF_RegSel),.OutC(OutC),.OutD(Address)
        
        
        
        );
endmodule