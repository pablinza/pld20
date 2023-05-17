/* Descripcion FSM moore para control de paso peatonal
 * utiliza dos pulsadores y retardo de repeticion 1 min 
 * Sistemas Digitales II laboratorio 5 de la Unidad 5 */
module fsm5(clk, rstn, btn1, btn2, sv1, sa1, sr1, pv1, pr1);
  input clk, rstn; //Reloj de 1KHz 
  input btn1, btn2; //pulsador activos en nivel bajo
  output reg sv1, sa1, sr1; //Luz de control vehicular
  output reg pv1, pr1;	//Luz de control peatonal
  reg [2:0] state; //Registro de 3-bits 8 estados
  localparam PARE = 3'b000; //No pasar, Vehicular Verde, Peatonal Rojo
  localparam ESPE = 3'b001; //No pasar, Espera con deteccion de pulsador
  localparam ATEN = 3'b010; //En espera, Vehicular Amarillo. 
  localparam PASE = 3'b011; //Pasar, Vehicular Rojo, Peatonal Verde
  localparam APRE = 3'b100; //Pasar, Destello peatonal verde
  reg  [7:0] cnt1; //contador  8-bit 0-255 (x 1ms = 0.25 seg)
  reg [15:0] cnt2; //contador 16-bit 0-65536 (x 1ms = 60 seg)
  reg but_flag; //Indicador de pulsador activado
  wire but = ~(btn1 & btn2); //Detecta pulsador activo

always @(posedge clk, negedge rstn) //Entrada, Estado y salida
begin
  if(rstn == 0) //Si reinicio esta activo
  begin
    cnt1 <= 8'd0;
    cnt2 <= 16'd49999; //Inicia con 50 seg
    but_flag <= 0;
	 sv1 <= 0; sa1 <= 0; sr1 <= 1; pv1 <= 0; pr1 <= 1;
    state <= PARE;
  end
  else
    case(state)
    PARE: //No pasar, Vehicular Verde, Peatonal Rojo
      begin
       sv1 <= 1; sa1 <= 0; sr1 <= 0; pv1 <= 0; pr1 <= 1; 
       if(but) but_flag <= 1;
       if(cnt2 <= 16'd59999) //con 60 seg
         begin
         cnt2 <= cnt2 + 1'b1;
         state <= PARE;  
         end    
       else 
         begin
         cnt2 <= 16'd0;
         state <= ESPE;
         end
      end
    ESPE: //No pasar, Espera con deteccion de pulsador 
      begin
        if(but_flag || but) state <= ATEN;
        else state <= ESPE;
      end
    ATEN: //En espera, Vehicular Amarillo
      begin
       sv1 <= 0; sa1 <= 1; sr1 <= 0; 
       but_flag <= 0;
       if(cnt2 < 16'd4999) //con 5 seg
         begin
         cnt2 <= cnt2 + 1'b1; 
         state <= ATEN;
         end
       else 
         begin
         cnt2 <= 16'd0;
         state <= PASE;
         end
      end
    PASE: //Pasar, Vehicular Rojo, Peatonal Verde
      begin
       sv1 <= 0; sa1 <= 0; sr1 <= 1; pv1 <= 1; pr1 <= 0;
       if(cnt2 < 16'd19999) //(+5 espera) +20 seg (+5 destello)
         begin
         cnt2 <= cnt2 + 1'b1; 
         state <= PASE;
         end
       else 
         begin
         cnt2 <= 16'd0;
         cnt1 <= 8'd0;
         state <= APRE;
         end
      end
    APRE: //Pasar, Destello peatonal verde
      begin
       if(cnt2 < 16'd4999) //con 5 seg
         begin
           cnt2 <= cnt2 + 1'b1; 
           state <= APRE;
	       if(cnt1 < 8'd249) cnt1 <= cnt1 + 1'b1;
         else
           begin
             cnt1 <= 8'd0;
             pv1 <= ! pv1; //destello led
           end
         end
       else 
         begin
         cnt2 <= 16'd0;
         state <= PARE;
         end
      end
    default: state <= PARE;
    endcase
end
endmodule
