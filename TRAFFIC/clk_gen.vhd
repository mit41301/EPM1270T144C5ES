library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
  port( 
        clk_in  : in  std_logic;
        clk_out1: out std_logic;
        clk_out2: out std_logic
      );
end clk_gen;

architecture a of clk_gen is
  signal cnt  : std_logic_vector(23 downto 0);
  signal reset: std_logic;
begin
  process (clk_in)
  begin
    if reset='1' then
      cnt<=(others=>'0');
    elsif clk_in'event and clk_in='1' then
      cnt<=cnt+1;
    end if;
  end process;
  reset<='1' when cnt=16000000 else '0';
  clk_out1<=cnt(23);
  clk_out2<=cnt(13);
end a;
