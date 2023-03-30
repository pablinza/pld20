module bcdtoseg(en, bcd, segment);
input en; //Habilitador de decodificador
input [3:0] bcd;//Numero binario de entrada
output [6:0] segment; //Salida a segmentos
reg [6:0] seg; //registro para guardar el segmento
assign segment = ~seg; //segmentos para anodo comun
always @(en, bcd)
 if(en) 
   case(bcd)//seg MSB (G)(F)(E)(D)(C)(B)(A)
	0: seg = 7'b0111111;
	1: seg = 7'b0000110;
	2: seg = 7'b1011011;
	3: seg = 7'b1001111;
	4: seg = 7'b1100110;
	5: seg = 7'b1101101;
	6: seg = 7'b1111100;
	7: seg = 7'b0000111;
	8: seg = 7'b1111111;
	9: seg = 7'b1100111;
	default: seg = 7'b0000000;
   endcase
 else seg = 7'b0000000;
endmodule
