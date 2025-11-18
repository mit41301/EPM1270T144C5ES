library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
entity alu is
port ( M  :in  std_logic;
       S  :in  std_logic_vector(1 downto 0);
       A,B:in  std_logic_vector(2 downto 0);
       F  :out std_logic_vector(2 downto 0));
end alu;
 
architecture a of alu is
begin
  process(S,A,B)
   begin
   if M='0' then
       case S is
         when "00"=>   --"000"
            F<=A and B;
         when "01"=>   --"001"
            F<=A or B;
         when "10"=>   --"010"
            F<=A xor B;
         when others=> --"011"
            F<=A nand B;
       end case;
    else
       case S is
         when "00"=>   --"100"
            F<=A+B;
         when "01"=>   --"101"
            F<=A-B;  
         when "10"=>   --"110"
            F<=A + "001";
         when others=> --"111"
            F<=A - "001";
       end case;
     end if;
   end process;
end a;
