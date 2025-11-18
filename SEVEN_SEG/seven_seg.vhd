library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity seven_seg is
  port (
         sw      : in  std_logic_vector(4 downto 1);
         dip     : in  std_logic_vector(5 to 8);
         seg_out : out std_logic_vector(7 downto 0);
         d       : out std_logic_vector(1 to 4)
        );
end seven_seg;

architecture arch of seven_seg is
begin
  d<= not sw;
  process (dip)
  begin
    case dip is
      when "0000" => seg_out <= "01000000";  -- 0   active low '0'
      when "0001" => seg_out <= "01111001";  -- 1
      when "0010" => seg_out <= "00100100";  -- 2
      when "0011" => seg_out <= "00110000";  -- 3
      when "0100" => seg_out <= "00011001";  -- 4
      when "0101" => seg_out <= "00010010";  -- 5
      when "0110" => seg_out <= "00000010";  -- 6
      when "0111" => seg_out <= "01111000";  -- 7
      when "1000" => seg_out <= "00000000";  -- 8
      when "1001" => seg_out <= "00010000";  -- 9
      when "1010" => seg_out <= "00001000";  -- a
      when "1011" => seg_out <= "00000011";  -- b  
      when "1100" => seg_out <= "01000110";  -- c
      when "1101" => seg_out <= "00100001";  -- d
      when "1110" => seg_out <= "00000110";  -- e
      when "1111" => seg_out <= "00001110";  -- f
      when others => seg_out <= "11111111";   
    end case;
  end process;
end arch;
