mescale 1ns / 1ps

`default_nettype none

module Design1 #(parameter N=8)(CLK,RST,IN_VALID,MODE,OPA,OPB,CMD,CE,CIN,ERR,RES,OFLOW,COUT,G,L,E,count);
input wire CLK,RST,MODE,CE,CIN;
input wire [N-1:0]OPA,OPB;
input wire [1:0]IN_VALID;
input wire [3:0]CMD;
output reg ERR,OFLOW,COUT,G,L,E;
output reg [2*N-1:0]RES;
output reg [1:0]count=0;


wire signed [N-1:0]sOPA = OPA;
wire signed [N-1:0]sOPB = OPB;

wire [N-1:0] s_add = sOPA + sOPB;
wire [N-1:0] s_sub = sOPA - sOPB;

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

  else if(CE)
  begin
  
  G<=0; L<=0; E<=0;
  OFLOW<=0;
  COUT<=0;
  ERR<=0;
  
  if(MODE) //Arithmrtic
   begin
       case(CMD)
            4'd0: begin
                 if(IN_VALID==2'b11)
                    begin
                    {COUT,RES[N-1:0]}<=OPA+OPB;
                    end
                    
                  else 
                    begin
                     RES<=0;
                     COUT<=0;
                    end
                   end
                   
            4'd1:begin
                  if(IN_VALID==2'b11)
                  begin
                    OFLOW<=0;
                    if(OPB>OPA)
                    begin
                       RES[N-1:0]<=OPA-OPB;
                       OFLOW<=1;
                    end
                    else
                     RES[N-1:0]<=OPA-OPB;
                  end
                  
                  else
                  begin 
                     RES<=0;
                     OFLOW<=0;
                  end
                  end
                  
            4'd2:begin
                  if(IN_VALID==2'b11)
                  begin
                    {COUT,RES[N-1:0]}<=OPA+OPB+CIN;
                  end
                  
                  else 
                     begin
                     RES<=0;
                     COUT<=0;
                     end  
                  end
                  
            4'd3:begin
                  if(IN_VALID==2'b11)
                  begin
                    RES[N-1:0]<=OPA-OPB-CIN;
                    if((OPB+CIN)>OPA)
                    begin
                      OFLOW<=1;
                      COUT<=1;
                    end
                    else
                    begin
                      OFLOW<=0;
                      COUT<=0;
                    end
                  end
             
                  else 
                     begin
                     RES<=0;
                     OFLOW<=0;
                     COUT<=0;
                     end  
                  end
                  
             4'd4:begin
                  if(IN_VALID==2'b01 || IN_VALID==2'b11)
                  begin
                    RES<=OPA+1;
                  end
                  
                  else 
                     begin
                     RES<=0;
                     end  
                  end
                  
              4'd5:begin
                  if(IN_VALID==2'b01 || IN_VALID==2'b11)
                  begin
                    RES<=OPA-1;
                  end
                  
                  else 
                     begin
                     RES<=0;
                     end  
                  end
                  
              4'd6:begin
                  if(IN_VALID==2'b10 || IN_VALID==2'b11)
                  begin
                    RES<=OPB+1;
                  end
                  
                  else 
                     begin
                     RES<=0;
                     end  
                  end
                  
             4'd7:begin
                  if(IN_VALID==2'b10 || IN_VALID==2'b11)
                  begin
                    RES<=OPB-1;
                  end
                  
                  else 
                     begin
                     RES<=0;
                     end  
                  end
                  
             4'd8:begin
                  if(IN_VALID==2'b11)
                  begin
                    G<=0; L<=0; E<=0;
                    if(OPA>OPB)
                      G<=1;
                    else if(OPA<OPB)
                      L<=1;
                    else 
                      E<=1;
                  end
                
                  else
                  begin
                    G<=0; L<=0; E<=0;
                  end
                end
                  
             4'd9:begin
                   if(IN_VALID==2'b11)
                   begin
                   if(count==0) 
                   begin 
                      count<=count+1;
                     end
                     
                   else if(count==1)
                   begin 
                      tempA<=OPA+1;
                      tempB<=OPB+1;
                      count<=count+1;
                    end
                    
                    else if(count==2)
                    begin
                       RES<=tempA*tempB;
                       count<=0;
                    end
                    
                    else
                       count<=0;
                       end
               else 
                   begin
                      RES<=0;
                      ERR<=1;
                   end
                   end      
                   
             4'd10:begin
                   if(IN_VALID==2'b11)
                   begin     
                    RES<=tempA*tempB;
                   end       i 
                   
                   else 
                   begin
                      RES<=0;
                   end
                   end
                  
                  4'd11	:begin	
				if( IN_VALID == 2'b11)
						begin
							RES[N-1:0] <= s_add;
							OFLOW = ( (OPA[N-1] == OPB[N-1]) && (s_add[N-1] != OPA[N-1]) );
					         end
								else	
								begin	
								  ERR <= 1;	RES <= 0;	
								 end
			                                        end
			      
				4'd12:begin	
				      if( IN_VALID == 2'b11)
						    begin
							RES[N-1:0] <= s_sub;
							OFLOW = ( (OPA[N-1] != OPB[N-1]) && (s_sub[N-1] != OPA[N-1]) );
						      end

								else	
								begin	
								 ERR <= 1;	
								 RES <= 0;	
								end
							end
							
				default:begin
				        RES<=0;
				        ERR<=1;
				        end
         endcase
    end
    
    
     else 
         begin
           case(CMD)
                4'd0:begin
                     if(IN_VALID==2'b11)
                         RES<=OPA&OPB;
                      else
                         RES<=0;
                     end
                     
                4'd1:begin
                     if(IN_VALID==2'b11)
                         RES<=~(OPA&OPB);
                      else
                         RES<=0;
                     end
                     
                4'd2:begin
                     if(IN_VALID==2'b11)
                         RES<=OPA|OPB;
                      else
                         RES<=0;
                     end
                     
                4'd3:begin
                     if(IN_VALID==2'b11)
                         RES<=~(OPA|OPB);
                      else
                         RES<=0;
                     end
                     
                4'd4:begin
                     if(IN_VALID==2'b11)
                         RES<=OPA^OPB;
                      else
                         RES<=0;
                     end
                     
                4'd5:begin
                     if(IN_VALID==2'b11)
                         RES<=~(OPA^OPB);
                      else
                         RES<=0;
                     end
                     
                4'd6:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES<=~OPA;
                      else
                         RES<=0;
                     end
                     
                 4'd7:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES<=~OPB;
                      else
                         RES<=0;
                     end
                     
                 4'd8:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES<=OPA>>1;
                      else
                         RES<=0;
                     end
                     
                 4'd9:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b01)
                         RES<=OPA<<1;
                      else
                         RES<=0;
                     end
                     
                 4'd10:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES<=OPB>>1;
                      else
                         RES<=0;
                     end
                     
                 4'd11:begin
                     if(IN_VALID==2'b11 || IN_VALID==2'b10)
                         RES<=OPB<<1;
                      else
                         RES<=0;
                     end
                     
                 4'd12:begin
                     if(IN_VALID==2'b11)
                         begin
                             ERR<=|OPB[7:4];
                             if(OPB[2:0]==3'b000)
                               RES[N-1:0]<=OPA; 
                               
                             else if(OPB[2:0]==3'b001)
                               RES[N-1:0]<={OPA[N-2:0],OPA[N-1]};
                                
                             else if(OPB[2:0]==3'b010)
                               RES[N-1:0]<={OPA[N-3:0],OPA[N-1:N-2]};
                                
                             else if(OPB[2:0]==3'b011)
                               RES[N-1:0]<={OPA[N-4:0],OPA[N-1:N-3]}; 
                               
                             else if(OPB[2:0]==3'b100)
                               RES[N-1:0]<={OPA[N-5:0],OPA[N-1:N-4]};
                                
                             else if(OPB[2:0]==3'b101)
                               RES[N-1:0]<={OPA[N-6:0],OPA[N-1:N-5]};
                                
                             else if(OPB[2:0]==3'b110)
                               RES[N-1:0]<={OPA[N-7:0],OPA[N-1:N-6]};
                                
                             else if(OPB[2:0]==3'b111)
                               RES[N-1:0]<={OPA[N-8:0],OPA[N-1:N-7]}; 
                        end
                      else
                        begin
                          RES<=0;
                          ERR<=0;
                        end
                     end
                        
                   4'd13:begin
                     if(IN_VALID==2'b11)
                         begin
                             ERR<=|OPB[7:4];
                             if(OPB[2:0]==3'b000)
                               RES[N-1:0]<=OPA; 
                             else if(OPB[2:0]==3'b001)
                               RES[N-1:0]<={OPA[0],OPA[N-1:1]};
                                
                             else if(OPB[2:0]==3'b010)
                               RES[N-1:0]<={OPA[1:0],OPA[N-1:2]};
                                
                             else if(OPB[2:0]==3'b011)
                               RES[N-1:0]<={OPA[2:0],OPA[N-1:3]};
                                
                             else if(OPB[2:0]==3'b100)
                               RES[N-1:0]<={OPA[3:0],OPA[N-1:4]};
                                
                             else if(OPB[2:0]==3'b101)
                               RES[N-1:0]<={OPA[4:0],OPA[N-1:5]};
                                
                             else if(OPB[2:0]==3'b110)
                               RES[N-1:0]<={OPA[5:0],OPA[N-1:6]};
                                
                             else if(OPB[2:0]==3'b111)
                               RES[N-1:0]<={OPA[6:0],OPA[N-1:7]}; 
                               
                        end
                      else
                        begin
                          RES<=0;
                          ERR<=0;
                        end
                     end

                  default:begin
                          RES<=0;
                          ERR<=1;
                          end
                            endcase
                        end
                        end
                    endmodule
