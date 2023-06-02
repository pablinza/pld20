/* Descripcion FSM moore para encoder rotatorio
 * salida dato incrementa o decrementa con giro encoder  
 * Sistemas Digitales II laboratorio 7 de la Unidad 5 */
module fsm6(clk, rstn, ina, inb, data);
input clk, rstn; //Frecuencia de muestro, recomandable 1Khz
input ina, inb; //Entradas del encoder, con desfase de 90
output [13:0] data; //Bus del contador 0000-9999
reg [13:0] cnt; //Contador 0-511 ms
localparam STA0 = 0; //Lectura INB=0 
localparam STA1 = 1; //Lectura INB=0,
localparam CHOK = 2; //Chequeo INA
localparam FWRD = 3; //Adelante
localparam BWRD = 4; //Atras
assign data = cnt;
reg[2:0] state; //Registro de estado

always @(posedge clk) //Sincronzado con reloj
if(rstn == 0) 
  begin
  state <= STA0; //Estado inicial
  cnt <= 14'd0;  //Reinicia contador
  end
else 
  case(state)
    STA0://Captura entrada A
    begin
		if(inb == 0) state <= STA1;
      else state <= STA0;
    end
    STA1: //Captura entrada A
      if(inb == 1) state <= CHOK;
      else state <= STA1;
    CHOK: //Verifica entrada B
	   if(ina == 1) state <= FWRD;//Adelante
       else state <= BWRD; //Atras
   FWRD: //Incrementa el contador
     begin
       if(cnt < 14'd9999) cnt <= cnt + 1;
       else cnt <= 14'd0;
       state <= STA0;
     end
   BWRD: //Decrementa el contador
     begin
       if(cnt > 0) cnt <= cnt - 1;
       else cnt <= 14'd9999;
       state <= STA0;
     end
	 default: state <= STA0; 
  endcase

endmodule
