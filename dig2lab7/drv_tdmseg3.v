/************************************************************
 * Modulo descriptivo para monstrar valores en 7 segmentos  *
 * Sistemas Digitales II, Pablo Zarate (pablinza@me.com)    *
 ***********************************************************/
module drv_tdmseg3(clk, rstn, data, segment, dden);
input clk;   //Reloj de 1KHz o t=1mS
input rstn;  //Reinicio activo en nivel bajo
input [9:0] data; //Bus del dato entero 10-bit 0-999
output [6:0] segment; //Bus de datos a 7 segmentos
output reg [2:0] dden; //Habilitador de display dden[0] = LSB
reg[1:0] dpos;  //Indicador de posicion 2-bit = 3 display
reg [3:0] bcd[2:0]; //Memoria WIDTH=4 DEPTH=3. (3x4bit)
reg[3:0] bcdout; //Dato temporal bcd para el tdm
reg [6:0] seg; //registro para guardar el segmento
assign segment = seg; //segmentos para catodo comun

always @(data) //Ciclo 1ms
  begin
    bcd[0]=(data) % 10; //LSB DDEN[0]
    bcd[1]=(data/10) % 10;
    bcd[2]=(data/100) % 10; //MSB DDEN[3]
  end


always @(posedge clk, negedge rstn)//Ciclo de 1ms
  if(rstn == 0)
  begin
    dpos <= 0;
    dden <= 3'b001; //Ajuste
    bcdout <= 4'd0;
  end
  else
    begin
      if(dpos < 2) dpos <= dpos + 1'b1; //Ajuste
      else dpos <= 0;
      bcdout = bcd[dpos];
      dden <= (3'b001 << dpos);      
    end

always @(bcdout)
  case(bcdout)//seg MSB (G)(F)(E)(D)(C)(B)(A)
    0: seg = 7'b0111111;
    1: seg = 7'b0000110;
    2: seg = 7'b1011011;
    3: seg = 7'b1001111;
    4: seg = 7'b1100110;
    5: seg = 7'b1101101;
    6: seg = 7'b1111100;
    7: seg = 7'b0000111;
    8: seg = 7'b1111111;
    9: seg = 7'b1100111;
    default: seg = 7'b0000000;
  endcase
endmodule
