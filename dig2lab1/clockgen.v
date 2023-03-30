module clockgen(clk, rstn, clko);
input clk;  //Reloj de 50MHz 
input rstn; //Reset activo en nivel bajo
output reg clko; //Salida de reloj 1Hz
reg [24:0] cnt; //log2(50M/2) medio periodo
always @(posedge clk or negedge rstn) //Para cada 0.02u (50MHz) 
  if(rstn==0) cnt <= 0;
  else
    if(cnt < 25000000) cnt <= cnt + 1'b1;//Equivale a 500ms 
    else
      begin
      clko = ~clko; //Equivale a 500ms 50M/2 => 0.5
	  cnt <= 0;   
      end
endmodule
