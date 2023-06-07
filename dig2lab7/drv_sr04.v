/************************************************************
 * Modulo descriptivo para lectura de sensor ultra HC-SR04  *
 * Sistemas Digitales II, Pablo Zarate (pablinza@me.com)    *
 ***********************************************************/
module drv_sr04(clk, rstn, trig, echo, start, data);
input clk;   //Reloj de 1MHz o t=1uS
input rstn;  //Reinicio activo en nivel bajo
input echo;  //Pin Eco del Sensor
input start; //Pulso para iniciar lectura
output reg trig;//Pin trigger del Sensor
output reg [9:0] data; //Dato distancia de 10-bits(0-511cm)
reg [14:0] cnt; //Contador de pulsos 15 bits
localparam INIT=0; //Espera disparo Start
localparam TRIG=1; //Dispara pulso por 10us
localparam ECHO=2; //Contador de pulso ECO
localparam WAIT=3; //Espera y calcula dato
reg [1:0] state; //registro de estados
reg start_d0, start_d1; //Registro para captura ET(Edge Transition)
wire start_flag; //Indicador de flanco, Bandera ET
assign start_flag = (~start_d1) & start_d0; //Asigna Transicion LTOH 
always @(posedge clk or negedge rstn)
begin
  if(rstn == 0)
  begin
    data <= 10'd123;
    cnt <= 15'd0;
    trig <= 1'b0;
    start_d0 <= 1'b0;
    start_d1 <= 1'b0;
    state <= INIT;
  end
  else
  begin
  start_d0 <= start; //Almacena estado actual
  start_d1 <= start_d0; //Almacena estado previo
  case(state)
    INIT:if(start_flag && (echo==0))
         begin
           trig <= 1'b1;
           cnt <= 15'd0;
           state <= TRIG;
         end
    TRIG:if(cnt > 19) //Espera los 10us
         begin
           trig <= 1'b0;
           cnt <= 15'd1; //Inicia en 1
       state <= ECHO;
         end
         else cnt <= cnt + 1'b1;
    ECHO:if(echo > 0)
           state <= WAIT;
    WAIT:if(echo < 1)
         begin
           data <= ((34 * cnt) / 2000); //(0.034cm * us)/2	
			  state <= INIT;
         end 
	     else
         begin        
           cnt <= cnt + 1'b1;
           if(cnt >= 15'h7FFF)
           begin
             data <= 10'd999;
             state <= INIT;
           end
         end
  endcase
  end
end
endmodule
