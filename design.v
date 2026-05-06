timescale 1ns / 1ps

`default_nettype none

module Design1 #(parameter N=4)(CLK,RST,IN_VALID,MODE,OPA,OPB,CMD,CE,CIN,ERR,RES,OFLOW,COUT,G,L,E);
input wire CLK,RST,MODE,CE,CIN;
input wire [N:0]OPA,OPB;
input wire [1:0]IN_VALID;
input wire [3:0]CMD;
output reg ERR,OFLOW,COUT,G,L,E;
output reg [2*N:0]RES;

reg count;
reg [N:0]tempA,tempB;


always @(posedge CLK or posedge RST)
if(RST)
begin
 ERR<=0;
 RES<=0;
 OFLOW<=0;
 COUT<=0;
 G<=0;
 L<=0;
 E<=0;
end
  else if(!CE)
    begin
       G<=0;
       L<=0;
       E<=0;

  else if(MODE)
   begin
       case(CMD)
            4'd0: begin
                 if(IN_VALID==2'b11)
                    begin
                    RES=OPA+OPB;
                    COUT=RES[8];
                    end
                    
                  else 
                    begin
                     RES=0;
                     COUT=0;
                    end
                   end
                   
            4'd1:begin
                  if(IN_VALID==2'b11)
                    OFLOW=0;
                  begin
                    if(OPB>OPA)
                    begin
                       RES=OPA-OPB;
                       OFLOW=1;
                    end
                    else
                    RES=OPA-OPB;
                  end
                  
                  else
                  begin 
                     RES=0;
                     OFLOW=0;
                  end
                  end
                  
            4'd2:begin
                  if(IN_VALID==2'b11)
                  begin
                    RES=OPA+OPB+CIN;
                    COUT=RES[N];
                  end
                  
                  else 
                     begin
                     RES=0;
                     COUT=0;
                     end  
                  end
                  
            4'd3:begin
                  if(IN_VALID==2'b11)
                  begin
                    RES=OPA-OPB-CIN;
                    COUT=RES[8];
                  end
                  
                  else 
                     begin
                     RES=0;
                     COUT=0;
                     end  
                  end
                  
             4'd4:begin
                  if(IN_VALID==2'b01 || IN_VALID==2'b11)
                  begin
                    RES=OPA+1;
                  end
                  
                  else 
                     begin
                     RES=0;
                     end  
                  end
                  
              4'd5:begin
                  if(IN_VALID==2'b01 || IN_VALID==2'b11)
                  begin
                    RES=OPA-1;
                  end
                  
                  else 
                     begin
                     RES=0;
                     end  
                  end
                  
              4'd6:begin
                  if(IN_VALID==2'b10 || IN_VALID==2'b11)
                  begin
                    RES=OPB+1;
                  end
                  
                  else 
                     begin
                     RES=0;
                     end  
                  end
                  
             4'd7:begin
                  if(IN_VALID==2'b10 || IN_VALID==2'b11)
                  begin
                    RES=OPB-1;
                  end
                  
                  else 
                     begin
                     RES=0;
                     end  
                  end
                  
             4'd8:begin
                  if(IN_VALID==2'b11)
                  begin
                    G=L=E=0;

                    if(OPA>OPB)
                      G=1;
                    else if(OPA<OPB)
                      L=1;
                    else 
                      E=1;
                  end
                  end
                  
             4'd9:begin
                   if(IN_VALID==2'b11)
                   begin
                       tempA=OPA+1;
                       tempB=OPB+1;
                       RES=tempA*tempB;
                   end
               
                   else
                      RES=0;
                   end      
                   
             4'd10:begin
                   if(IN_VALID==2'b11)
                   begin     
                      tempA=OPA<<1;
                      RES=tempA*OPB;
                   end        
                   
                   else 
                      RES=0;
                   end
                  
             4'd11:begin
                   if(IN_VALID==2'b11)
                   begin
                   RES=$signed(OPA)+$signed(OPB);
                   COUT=RES[8];
                   G=(OPA>OPB);
                   L=(OPA<OPB);
                   E=(OPA==OPB);     
                   end
                   
             4'd12:begin
                   if(IN_VALID==2'b11)
                   begin
                   RES=$signed(OPA)-$signed(OPB);
                   OFLOW=(OPA<OPB);
                   G=(OPA>OPB);
                   L=(OPA<OPB);
                   E=(OPA==OPB);
                   end
                   
                   end
         endcase
    end
    
    
     else 
         begin
           case(CMD)
                4'd0:begin
                     if(IN_VALID==2'b11)
                         RES=OPA&OPB;
                      else
                         RES=0;
                     end
                     
                4'd1:begin
                     if(IN_VALID==2'b11)
                         RES=~(OPA&OPB);
                      else
                         RES=0;
                     end
                     
                4'd2:begin
                     if(IN_VALID==2'b11)
                         RES=OPA|OPB;
                      else
                         RES=0;
                     end
                     
                4'd3:begin
                     if(IN_VALID==2'b11)
                         RES=~(OPA|OPB);
                      else
                         RES=0;
                     end
                     
                4'd4:begin
                     if(IN_VALID==2'b11)
                         RES=OPA^OPB;
                      else
                         RES=0;
                     end
                     
                4'd5:begin
                     if(IN_VALID==2'b11)
                         RES=~(OPA^OPB);
                      else
                         RES=0;
                     end
                     
                4'd6:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES=~OPA;
                      else
                         RES=0;
                     end
                     
                 4'd7:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES=~OPB;
                      else
                         RES=0;
                     end
                     
                 4'd8:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES=OPA>>1;
                      else
                         RES=0;
                     end
                     
                 4'd9:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES=OPA<<1;
                      else
                         RES=0;
                     end
                     
                 4'd10:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES=OPB>>1;
                      else
                         RES=0;
                     end
                     
                 4'd11:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES=OPB<<1;
                      else
                         RES=0;
                     end
                     
                 4'd12:begin
                     if(IN_VALID==2'b11)
                         begin
                             if(|OPB[7:4]==0 && OPB[2:0]==3'b000)
                               RES=OPA; 
                               
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b000)
                             begin
                               RES=OPA; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b001)
                             begin
                               RES={OPA[6:0],OPA[7]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b001)
                             begin
                               RES={OPA[6:0],OPA[7]};           
                               ERR=1; 
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b010)
                             begin
                               RES={OPA[5:0],OPA[7:6]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b010)
                             begin
                               RES={OPA[5:0],OPA[7:6]};
                               ERR=1; 
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b011)
                             begin
                               RES={OPA[4:0],OPA[7:5]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b011)
                             begin
                               RES={OPA[4:0],OPA[7:5]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b100)
                             begin
                               RES={OPA[3:0],OPA[7:4]}; 
                             end 
                            
                            else if(|OPB[7:4]==1 && OPB[2:0]==3'b100)
                             begin
                               RES={OPA[3:0],OPA[7:4]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b101)
                             begin
                               RES={OPA[2:0],OPA[7:3]}; 
                             end 
                         
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b101)
                             begin
                               RES={OPA[2:0],OPA[7:3]};
                               ERR=1; 
                             end 
                         
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b110)
                             begin
                               RES={OPA[1:0],OPA[7:2]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b110)
                             begin
                               RES={OPA[1:0],OPA[7:2]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b111)
                             begin
                               RES={OPA[0],OPA[7:1]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b111)
                             begin
                               RES={OPA[0],OPA[7:1]};
                               ERR=1; 
                             end 
                        end
                     end
                        
                   4'd13:begin
                     if(IN_VALID==2'b11)
                         begin
                             if(|OPB[7:4]==0 && OPB[2:0]==3'b000)
                               RES=OPA; 
                               
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b000)
                             begin
                               RES=OPA; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b001)
                             begin
                               RES={OPA[0],OPA[7:1]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b001)
                             begin
                               RES={OPA[0],OPA[7:1]};           
                               ERR=1; 
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b010)
                             begin
                               RES={OPA[1:0],OPA[7:2]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b010)
                             begin
                               RES={OPA[1:0],OPA[7:2]};
                               ERR=1; 
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b011)
                             begin
                               RES={OPA[2:0],OPA[7:3]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b011)
                             begin
                               RES={OPA[2:0],OPA[7:3]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b100)
                             begin
                               RES={OPA[3:0],OPA[7:4]}; 
                             end 
                            
                            else if(|OPB[7:4]==1 && OPB[2:0]==3'b100)
                             begin
                               RES={OPA[3:0],OPA[7:4]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b101)
                             begin
                               RES={OPA[4:0],OPA[7:5]}; 
                             end 
                         
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b101)
                             begin
                               RES={OPA[4:0],OPA[7:5]};
                               ERR=1; 
                             end 
                         
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b110)
                             begin
                               RES={OPA[5:0],OPA[7:6]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b110)
                             begin
                               RES={OPA[5:0],OPA[7:6]}; 
                               ERR=1;
                             end 
                             
                             else if(|OPB[7:4]==0 && OPB[2:0]==3'b111)
                             begin
                               RES={OPA[6:0],OPA[7]}; 
                             end 
                             
                             else if(|OPB[7:4]==1 && OPB[2:0]==3'b111)
                             begin
                               RES={OPA[6:0],OPA[7]};
                               ERR=1; 
                             end
                             end
                             end
                            endcase
                        end
                        
                    endmodule

