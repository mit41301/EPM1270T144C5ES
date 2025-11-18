library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity bin2seg0_scan is
  port (
        clk_scan  : in  std_logic;
        rst       : in  std_logic;
        seg_en    : in  std_logic;
        min_ten   : in  std_logic_vector(3 downto 0);
        min_one   : in  std_logic_vector(3 downto 0);
        sec_ten   : in  std_logic_vector(3 downto 0);
        sec_one   : in  std_logic_vector(3 downto 0);
        seven_seg : out std_logic_vector(7 downto 0);
        dig1,dig2,dig3,dig4: out std_logic 
       );
end bin2seg0_scan;

architecture arch of bin2seg0_scan is
  signal bin: std_logic_vector(3 downto 0);
  signal sel: integer range 0 to 3;
begin
  process (clk_scan,rst)
  begin
    if rst='0' then
      dig2<='0';dig1<='0';dig4<='0';dig3<='0';
      sel<=0;
    elsif clk_scan'event and clk_scan='1' then
      sel<=sel+1;
      case sel is
        when 0 =>
          bin<=sec_one;
          dig4<='0';dig3<='0';dig2<='0';dig1<='1';
        when 1 =>
          bin<=sec_ten;
          dig4<='0';dig3<='0';dig2<='1';dig1<='0';
        when 2 =>
          bin<=min_one;
          dig4<='0';dig3<='1';dig2<='0';dig1<='0';
        when 3 =>
          bin<=min_ten;
          dig4<='1';dig3<='0';dig2<='0';dig1<='0';
        when others =>
          null;
      end case;
    end if;
  end process;

  process (bin)
  begin
    case bin is
      when "0000" => seven_seg <= "01000000";
      when "0001" => seven_seg <= "01111001";
      when "0010" => seven_seg <= "00100100";
      when "0011" => seven_seg <= "00110000";
      when "0100" => seven_seg <= "00011001";
      when "0101" => seven_seg <= "00010010";
      when "0110" => seven_seg <= "00000010";
      when "0111" => seven_seg <= "01111000";
      when "1000" => seven_seg <= "00000000";
      when "1001" => seven_seg <= "00010000";
      when "1111" => seven_seg <= "00001110";
      when others => seven_seg <= "11111111";   
    end case;
  end process;
end arch;
