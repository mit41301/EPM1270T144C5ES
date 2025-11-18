library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game is
  port(
        clk : in  std_logic;
        rst : in  std_logic;
        sw1,sw2 : in  std_logic;
        seg_out   : out std_logic_vector(7 downto 0);
        seg_one_en: out std_logic;
        seg_ten_en: out std_logic;
        led: out std_logic_vector(7 downto 0)
      );
end game;

architecture a of game is
  signal cnt_one,cnt_ten : std_logic_vector(3 downto 0);
  signal s,s0,s1 : std_logic;
begin
  process (clk,rst)
  begin
    if rst='0' then
      cnt_one <= "0001";
      cnt_ten <= "0000";
      s0 <= '1'; s1 <= '1';
    elsif clk'event and clk='1' then
      s1<=s0; s0<=sel;
      if cnt_ten = "0100" then    --40
        if cnt_one = "0010" then
          cnt_one <= "0001";      --1
          cnt_ten <= "0000";
        else
          cnt_one <= cnt_one + 1;
        end if;
      elsif cnt_one = "1001" then
        cnt_one <= "0000";
        cnt_ten <= cnt_ten + 1;
      else
        cnt_one <= cnt_one + 1;
      end if;
    end if;
  end process;

  s <= s1 and not s0;

  process(clk,rst)
  begin
    if clk'event and clk='1' then
      if rst='0' then
        q_one <= "0000";
        q_ten <= "0000";
      elsif s = '1' then
        q_one <= cnt_one;
        q_ten <= cnt_ten;
      end if;
    end if;
  end process;
end a;

