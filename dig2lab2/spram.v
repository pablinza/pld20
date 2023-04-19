//Descripcion de una memoria con registros  FF
//Matriz de 16 x 4 bits, total 64bits
module spram(clk, wen, addr, data, qout); 
input clk; //Frecuencia de operacion 
input wen; //Selector operacion lectura/escritura
input  [3:0] addr;  //Bus de direcciones
input  [3:0] data;  //Bus datos de entrada
output [3:0] qout;  //Bus datos de salida
reg [3:0] ram[15:0];//Matriz de celdas
reg [3:0] addr_ptr; //Puntero de posicion
assign qout = ram[addr_ptr];//Asignacion de salida
always @ (posedge clk)
  begin
  if(wen==0) ram[addr] <= data; //Carga el valor en posicion	
  addr_ptr <= addr; //Actualiza puntero de posicion
  end	
endmodule