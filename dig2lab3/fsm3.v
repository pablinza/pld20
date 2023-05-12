/* Descripcion de un FSM moore para detectar 0-1-0-0-1-0  
 * Sistemas Digitales II ejemplo 5 de la Unidad 5 */
module fsm3(clk, rstn, e, s);
  input clk, rstn, e;
  output reg s;
  reg [2:0] state, nextstate; //Registro de 3-bits 8 estados
  localparam S0=3'b000; //Estado inicial
  localparam S1=3'b001; //Detectado 0
  localparam S2=3'b010; //Detectado 0-1
  localparam S3=3'b011; //Detectado 0-1-0
  localparam S4=3'b100; //Detectado 0-1-0-0
  localparam S5=3'b101; //Detectado 0-1-0-0-1
  localparam S6=3'b110; //Detectado 0-1-0-0-1-0

always @(posedge clk, negedge rstn) //Registro de estado 
  if(rstn == 0) state <= S0;
  else state <= nextstate;

always @(e, state) //Estado siguiente y salida
  case(state)
    S0:begin //Estado inicial salida 0
       s <= 0;
       if(e==0) nextstate <= S1;
       else nextstate <= S0;
       end
    S1:if(e==1) nextstate <= S2;
       else nextstate <= S1;
    S2:if(e==0) nextstate <= S3;
       else nextstate <= S0;
    S3:if(e==0) nextstate <= S4;
       else nextstate <= S2;
    S4:if(e==1) nextstate <= S5;
       else nextstate <= S1;
    S5:if(e==0) nextstate <= S6;
       else nextstate <= S0;
    S6:begin //Estado final salida 1
       s <= 1;
       nextstate <= S6;
       end
    default: nextstate <= S0;
  endcase
endmodule
