library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity br_gen is
  generic(divisor: integer := 26);
port(
     sysclk:in std_logic;           
     sel   :in std_logic_vector(2 downto 0);
     bclkx8:buffer std_logic;        
     bclk  :out std_logic             
    );
end br_gen;

architecture arch of br_gen is
  signal cnt2,clkdiv: std_logic;
  signal ctr2: std_logic_vector (7 downto 0):= "00000000";
  signal ctr3: std_logic_vector (2 downto 0):= "000";
begin
  process (sysclk)
    variable cnt1     : integer range 0 to divisor;
    variable divisor2 : integer range 0 to divisor;
  begin
    divisor2 := divisor/2;
    if (sysclk'event and sysclk='1') then
      if cnt1=divisor then
        cnt1 := 1;
      else
        cnt1 := cnt1 + 1;
      end if;	
    end if;
    if (sysclk'event and sysclk='1') then
      if (( cnt1=divisor2) or (cnt1=divisor)) then	
        cnt2 <= not cnt2;
      end if;
    end if;
  end process;
  clkdiv<=  cnt2 ;
  process (clkdiv)	
  begin
    if(rising_edge(clkdiv)) then
      ctr2 <= ctr2+1;
    end if;
  end process;
  bclkx8<=ctr2(CONV_INTEGER(sel));
  process (bclkx8)
  begin
    if(rising_edge(bclkx8)) then
      ctr3 <= ctr3+1;
    end if;
  end process;
  bclk <= ctr3(2);    
end arch;
