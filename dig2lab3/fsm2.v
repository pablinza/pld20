//SIN PROBAR
/* Descripcion de una FSM moore control de nivel   
 * Sistemas Digitales II ejemplo 4 de la Unidad 5 */
module fsm2(clk, rstn, e1, e2, s1, s2, m1);
input clk; //Requiere reloj de 1Khz
input rstn;
input e1, e2;
output reg s1, s2, m1;
parameter DEBOUNCE=2000; //2 seg
localparam VACIO=0; //Deposito vacio, activa motor
localparam MEDIA=1; //Cargando, o en descarga
localparam LLENO=2; //Deposito lleno, apaga motor
reg [1:0] state, nextstate;
reg [9:0] cnt;
reg e_flag;
reg [1:0] e_reg0, e_reg1;
always @(posedge clk, rstn)
if(rstn == 0) state <= LLENO;
else state <=  nextstate;

always @(posedge clk)
begin
  cnt <= cnt + 1;
  e_reg0 <= {e2,e1};//Registra entradas
  if(e_reg1 != e_reg0)//Compara con valor anterior
    if(cnt == DEBOUNCE)
      begin
      e_reg1 <= e_reg0;
      e_flag <= 1;
      end
    else e_flag <= 0;
  else cnt <= 0;
end

always @(state, e2, e1)
case(state)
  LLENO: 
    begin
    m1 <= 0;
    s2 <= 1;
    s1 <= 0;
    if(e2==1) nextstate <= MEDIA;
    else nextstate <= LLENO;
    end
  VACIO:
    begin
    m1 <= 1;
    s2 <= 0;
    s1 <= 1;
    if(e1==0) nextstate <= MEDIA;
    else nextstate <= VACIO;
    end
  MEDIA:
    begin
    s1 <= 0;
    s2 <= 0;
    if(e1==0 && e2==0) nextstate <= LLENO;
    else
      if(e1==1 && e2==1) nextstate <= VACIO;
      else nextstate <= MEDIA;
    end 
endcase
endmodule
