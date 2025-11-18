library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity uart_receiver is
port(
       sysclk    :in  std_logic;    
       rst_n     :in  std_logic;   
       bclkx8    :in  std_logic;     
       rxd       :in  std_logic;     
       rxd_readyH:out std_logic;    
       RDR       :out std_logic_vector(7 downto 0)
    ); 
end uart_receiver;

architecture arch of uart_receiver is
  type statetype is (idle,start_detected,recv_data);
  signal state,nextstate:statetype;
  signal inc1,inc2,clr1,clr2:std_logic;     
  signal shftRSR,load_RDR:std_logic;        
  signal bclkx8_dlayed,bclkx8_rising:std_logic;
  signal RSR:std_logic_vector(7 downto 0);
  signal ct1:integer range 0 to 7; 
  signal ct2:integer range 0 to 8; 
  signal ok_en: std_logic;
begin
bclkx8_rising<=bclkx8 and(not bclkx8_dlayed);
process(state,rxd,ct1,ct2,bclkx8_rising)
begin
  inc1<='0';inc2<='0';clr1<='0';clr2<='0';
  shftRSR<='0';load_RDR<='0';ok_en<='0';
  case state is
    when idle=>
      if (rxd='0') then        
        nextstate<=start_detected;
      else
        nextstate<=idle;
      end if;
    when start_detected=>
      if (bclkx8_rising='0') then
        nextstate<=start_detected;
      elsif (rxd='1') then     
        clr1<='1';              
        nextstate<=idle;       
      elsif (ct1=3) then
        clr1<='1';                
        nextstate<=recv_data;     
      else
        inc1<='1';                
        nextstate<=start_detected; 
      end if;
    when recv_data=>
      if (bclkx8_rising='0') then
        nextstate<=recv_data;
      else
        inc1<='1';
        if (ct1/=7) then       
          nextstate<=recv_data;
        elsif (ct2/=8) then     
          shftRSR<='1';        
          inc2<='1';           
          clr1<='1';            
          nextstate<=recv_data;  
        elsif (rxd='0') then   
          nextstate<=idle;      
          clr1<='1';            
          clr2<='1';            
        else                    
          load_RDR<='1';        
          ok_en<='1';
          clr1<='1';            
          clr2<='1';            
          nextstate<=idle;      
        end if;
      end if;
    end case; 
  end  process;
  process(sysclk,rst_n)
  begin
    if (rst_n='0') then
      state<=idle;
      bclkx8_dlayed<='0';
      ct1<=0;
      ct2<=0;
      RDR<="00101011";
    elsif (sysclk'event and sysclk='1') then
      state<=nextstate;
    
      if(clr1='1')then ct1<=0;elsif(inc1='1')then ct1<=ct1+1;end if;

      if(clr2='1')then ct2<=0;elsif(inc2='1')then ct2<=ct2+1;end if;   
    
      if(shftRSR='1')then RSR<=rxd & RSR(7 downto 1);end if;

      if(load_RDR='1')then RDR<=RSR;end if;

      if(ok_en='1')then rxd_readyH<='1';else rxd_readyH<='0';end if;
      bclkx8_dlayed<=bclkx8;
    end if;
  end process;
end arch;
