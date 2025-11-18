library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity scan is
  port (
         clk,clk_scan,rst : in  std_logic;
         rxd_readyH       : in  std_logic;
         rxd_data         : in  std_logic_vector(7 downto 0);
         seven_seg        : out std_logic_vector(7 downto 0);
         com_mten,com_mone: out std_logic;
         com_sten,com_sone: out std_logic);
end scan;

architecture arch of scan is
  signal bin: std_logic_vector(3 downto 0);
  signal sel: integer range 0 to 3;
  signal min_ten,min_one: std_logic_vector(3 downto 0);
  signal sec_ten,sec_one: std_logic_vector(3 downto 0);
begin

  process (clk,rxd_readyH)
  begin
    if rst='0' then
        sec_one<=rxd_data(3 downto 0);
        sec_ten<=rxd_data(7 downto 4);
        min_one<="0000";
        min_ten<="0000";
    elsif clk'event and clk='1' then
      if rxd_readyH='1' then
        sec_one<=rxd_data(3 downto 0);
        sec_ten<=rxd_data(7 downto 4);
        min_one<=sec_one;
        min_ten<=sec_ten;
      end if;
    end if;
  end process;        

  process (clk_scan,rst)
  begin
    if rst='0' then
      com_sten<='0';com_sone<='0';com_mten<='0';com_mone<='0';
      sel<=0;
    elsif clk_scan'event and clk_scan='1' then
      sel<=sel+1;
      case sel is
        when 0 =>
          bin<=sec_one;
          com_mten<='0';com_mone<='0';com_sten<='0';com_sone<='1';
        when 1 =>
          bin<=sec_ten;
          com_mten<='0';com_mone<='0';com_sten<='1';com_sone<='0';
        when 2 =>
          bin<=min_one;
          com_mten<='0';com_mone<='1';com_sten<='0';com_sone<='0';
        when 3 =>
          bin<=min_ten;
          com_mten<='1';com_mone<='0';com_sten<='0';com_sone<='0';
        when others =>
          null;
      end case;
    end if;
  end process;

  process (bin)
  begin
    case bin is
      when "0000" => seven_seg <= "01000000";  -- 0
      when "0001" => seven_seg <= "01111001";  -- 1
      when "0010" => seven_seg <= "00100100";  -- 2
      when "0011" => seven_seg <= "00110000";  -- 3
      when "0100" => seven_seg <= "00011001";  -- 4
      when "0101" => seven_seg <= "00010010";  -- 5
      when "0110" => seven_seg <= "00000010";  -- 6
      when "0111" => seven_seg <= "01111000";  -- 7
      when "1000" => seven_seg <= "00000000";  -- 8
      when "1001" => seven_seg <= "00010000";  -- 9
      when "1010" => seven_seg <= "00001000";  -- a
      when "1011" => seven_seg <= "00000011";  -- b
      when "1100" => seven_seg <= "01000110";  -- c
      when "1101" => seven_seg <= "00100001";  -- d
      when "1110" => seven_seg <= "00000110";  -- e
      when "1111" => seven_seg <= "00001110";  -- f
      when others => seven_seg <= "01111111";   
    end case;
  end process;
end arch;
