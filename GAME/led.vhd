library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity led is
  port( 
       clk :in  std_logic;
       rst :in  std_logic;
       sel :in  std_logic_vector(1 downto 0); 
       led :out std_logic_vector(7 downto 0)
      );
end led;

architecture a of led  is
  signal cnt   : std_logic_vector(2 downto 0);
  signal led_t1,led_t2:std_logic_vector(7 downto 0);
begin

  process(clk,rst)
  begin
    if rst='0' then
      cnt<="000";
    elsif clk'event and clk='1' then
        cnt<=cnt+1;
    end if;
  end process;

  led_t1<="11111110" when cnt="000" else
          "11111101" when cnt="001" else
          "11111011" when cnt="010" else
          "11110111" when cnt="011" else
          "01111111" when cnt="100" else
          "10111111" when cnt="101" else
          "11011111" when cnt="110" else
          "11101111";
  led_t2<="00000000" when cnt="000" else
          "11111111" when cnt="001" else
          "00000000" when cnt="010" else
          "11111111" when cnt="011" else
          "00000000" when cnt="100" else
          "11111111" when cnt="101" else
          "00000000" when cnt="110" else
          "11111111";

  led <= led_t1 when sel="01" else
         led_t2 when sel="10" else
         "11111111";
end a;