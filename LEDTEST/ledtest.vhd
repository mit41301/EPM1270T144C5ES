library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ledtest is
  port( 
       clk :in  std_logic;
       rst :in  std_logic;
       u_d :in  std_logic; 
       sel :in  std_logic_vector(1 downto 0);
       led :out std_logic_vector(7 downto 0)
      );
end ledtest;

architecture a of ledtest  is
  signal cnt   : std_logic_vector(2 downto 0);
  signal clkcnt: std_logic_vector(19 downto 0);
  signal clk2  : std_logic;
  signal led_t1,led_t2,led_t3,led_t4:std_logic_vector(7 downto 0);
begin

  process(rst,clk)
  begin
    if rst='0' then
      clkcnt<=(others=>'0');
      clk2<='0';
    elsif clk'event and clk='1' then
      if clkcnt="11110100001001000000" then
        clk2<=not clk2;
        clkcnt<=(others=>'0');
      else
        clkcnt<=clkcnt+1;
      end if;
    end if;
  end process;

  process(rst,clk2)
  begin
    if rst='0' then
      cnt<="000";
    elsif clk2'event and clk2='1' then
      if u_d='1' then
        cnt<=cnt+1;
      else
        cnt<=cnt-1;
      end if;
    end if;
  end process;

  led_t1<="11111110" when cnt="000" else
          "11111101" when cnt="001" else
          "11111011" when cnt="010" else
          "11110111" when cnt="011" else
          "11101111" when cnt="100" else
          "11011111" when cnt="101" else
          "10111111" when cnt="110" else
          "01111111";
  
  led_t2<="01111110" when cnt="000" else
          "10111101" when cnt="001" else
          "11011011" when cnt="010" else
          "11100111" when cnt="011" else
          "01111110" when cnt="100" else
          "10111101" when cnt="101" else
          "11011011" when cnt="110" else
          "11100111";
  
  led_t3<="00000000" when cnt="000" else
          "11111111" when cnt="001" else
          "00000000" when cnt="010" else
          "11111111" when cnt="011" else
          "00000000" when cnt="100" else
          "11111111" when cnt="101" else
          "00000000" when cnt="110" else
          "11111111";
  
  led_t4<="11101110" when cnt="000" else
          "11011101" when cnt="001" else
          "10111011" when cnt="010" else
          "01110111" when cnt="011" else
          "10111011" when cnt="100" else
          "11011101" when cnt="101" else
          "11101110" when cnt="110" else
          "11111111";
  
  led <= led_t2 when sel="10" else
         led_t3 when sel="01" else
         led_t4 when sel="00" else
         led_t1;
end a;