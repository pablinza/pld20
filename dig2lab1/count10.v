module count10(clk, rstn, bcd);
input clk, rstn; //Reloj de 1Hz para contador
output [3:0] bcd;//Bus de salida del contador
reg[3:0] cnt;    //Registro contador 4-bit
assign bcd = cnt;//Asigna el registro a la salida
always @(posedge clk, negedge rstn) 
  if(!rstn) cnt <= 0; 
  else
    if(cnt >= 9) cnt <= 0;//Reinicio contador
    else cnt <= cnt + 1'b1;  //Incremento contador
endmodule
