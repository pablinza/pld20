/************************************************************
 * Modulo descriptivo para control de motor PAP Unipolar    *
 * control velocidad 3-bit pasos de 10ms-20ms-30ms....80ms  *   
 * Sistemas Digitales II, Pablo Zarate (pablinza@me.com)    *
 ***********************************************************/
module drv_stepmotor(clk, rstn, en, dir, speed, out);
input clk, rstn; //Entrada de reloj 1ms
input en; //Habilitador 
input dir; //Direccion adelante=1, atras=0
input [2:0] speed;//Control de velocidad 3 bits
output [3:0] out; //Salida del motor L1L2L3L4
reg [3:0] motor; //L1L2L3L4 Motor de prueba(28BYJ-48)
assign out = motor;
reg [5:0] cnt; //Contador 6-bits 0-63
reg[1:0] state, nextstate; //Registros de estado
reg clk1;

always @(posedge clk, negedge rstn)
  if(rstn == 0)
    begin 
    cnt <= 6'd0;
    clk1 <= 1'b0;
    end
  else
    if(cnt < (5*(speed+1)-1)) cnt <= cnt + 1'b1; 
    else
      begin
      cnt <= 6'd0;
      clk1 <= ~clk1; //Senal de reloj para el motor
      end
 
always @(posedge clk1, negedge rstn)
if(rstn == 0) state <= 2'd0;
else 
  if(en==1'b1) state <= nextstate;
  else state <= state;

always @(state)
  case(state)
  2'd0:begin
    motor <= 4'b1001;
    if(dir) nextstate <= 2'd3;
    else nextstate <= 2'd1;
    end
  2'd1:begin
    motor <= 4'b0011;
    if(dir) nextstate <= 2'd0;
    else nextstate <= 2'd2;
    end
  2'd2:begin
    motor <= 4'b0110;
    if(dir) nextstate <= 2'd1;
    else nextstate <= 2'd3;
    end
  2'd3:begin
    motor <= 4'b1100;
    if(dir) nextstate <= 2;
    else nextstate <= 2'd0;
    end
  endcase
endmodule
