//SIN PROBAR
/* Descripcion de una FSM moore para detectar  1-1  
 * Sistemas Digitales II ejemplo 3 de la Unidad 5 */
module fsm1(clk, rstn, e1, s1);
  input clk, rstn, e1;
  output reg s1;
  reg [1:0] state, nextstate;
  localparam S0=0, S1=1, S2=2;

always @(posedge clk)
  if(rstn == 0) state = S0;
  else state <= nextstate;

always @(e1, state)
  case(state)
    S0:begin
        s1 <= 0;
        if(e1==1) nextstate <= S1;
        else nextstate <= S0;
       end
    S1:begin
        if(e1==1) nextstate <=S2;
        else nextstate <= S0;
       end
    S2:begin
        s1 <= 1;
        if(e1==1) nextstate <=S2;
        else nextstate <= S0;
       end
    default: nextstate <= S0;
  endcase
endmodule
