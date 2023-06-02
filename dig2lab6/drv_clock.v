/************************************************************
 * Modulo descriptivo para generador de pulsos de reloj     *
 * Codigo parametrizado con valores SYSFREQ/OUTFREQ en Hz   *
 * Sistemas Digitales II, Pablo Zarate (pablinza@me.com)    *
 ***********************************************************/
module drv_clock(clk, rstn, clko);
input clk, rstn; //Entrada de reloj principal 
output reg clko; //Salida de reloj 
parameter SYSFREQ = 50000000; //Frecuencia principal en Hz
parameter OUTFREQ =  1000000; //Frecuencia de salida en Hz
localparam halfOUTFREQ = (SYSFREQ/OUTFREQ)/2;
localparam WIDTH = $clog2(halfOUTFREQ); //Medio ciclo
reg [WIDTH-1:0] cnt; //Contador para medio ciclo OUTFREQ
always @(posedge clk or negedge rstn) //Para cada 0.02u (50MHz) 
if(!rstn)
  begin 
  clko <= 0;
  cnt <= 0;
  end
else
  begin
    if(cnt < (halfOUTFREQ-1)) //medio ciclo 
    cnt <= cnt + 1'd1;
    else
      begin
      clko = ~clko;
	  cnt <= 0;   
      end
  end
endmodule
