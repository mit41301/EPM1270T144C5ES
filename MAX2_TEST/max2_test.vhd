------------------------------------------
--範例名稱：MAX2 Starter Kit測試
--功    能：DIP ON -> LED 亮
--          7Segment:時鐘功能;顯示分與秒
--          SW1:重置;SW2:制能
--          SW3:關閉分時間;SW4:關閉秒時間
------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity max2_test is
  Port( clk,rst,en: in std_logic;
        dip       : in std_logic_vector(7 downto 0);
        sw3,sw4   : in std_logic;
        led       : out std_logic_vector(7 downto 0);
        seven_seg :out std_logic_vector(7 downto 0);
        dig4,dig3,dig2,dig1:out std_logic);
end max2_test;

architecture arch of max2_test is
  signal clk_cnt,clk_scan:std_logic;
  signal min_ten,min_one,sec_ten,sec_one:std_logic_vector(3 downto 0);
  signal com_sten,com_sone,com_mten,com_mone:std_logic;
  signal en_d0,en_d1,en_d2,ce:std_logic;  
begin

led<=dip;

dig4<=com_mten when sw3='1' else '0';
dig3<=com_mone when sw3='1' else '0';
dig2<=com_sten when sw4='1' else '0';
dig1<=com_sone when sw4='1' else '0';

clk_div:block
  signal cnt  : std_logic_vector(23 downto 0);
  signal reset: std_logic;
begin
  process (clk)
  begin
    if reset='1' then
      cnt<=(others=>'0');
    elsif clk'event and clk='1' then
      cnt<=cnt+1;
    end if;
  end process;
  reset<='1' when cnt=16000000 else '0';
  clk_cnt<=cnt(23); 
  clk_scan<=cnt(13); 
end block clk_div;

counter:block
begin
  process (clk_cnt,rst,en)
  begin
    if rst='0' then
      min_ten<="0000";min_one<="0000";
      sec_ten<="0000";sec_one<="0000";
    elsif clk_cnt'event and clk_cnt='1' then
      if ce='1' then
        if sec_one="1001" then
          if sec_ten="0101" then
            if min_one="1001" then
              if min_ten="0101" then
                min_ten<="0000";min_one<="0000";
                sec_ten<="0000";sec_one<="0000";
              else
                min_ten<=min_ten+1;min_one<="0000";
                sec_ten<="0000";sec_one<="0000";
              end if;
            else
              min_one<=min_one+1;
              sec_ten<="0000";sec_one<="0000";
            end if;
          else
            sec_ten<=sec_ten+1;
            sec_one<="0000";
          end if;
        else
          sec_one<=sec_one+1;
        end if;
      end if;
    end if;
  end process;
end block counter;

scan:block
  signal bin: std_logic_vector(3 downto 0);
  signal sel: integer range 0 to 3;
begin
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
      when others => seven_seg <= "01111111";   
    end case;
  end process;
end block scan;

  process (clk)
  begin
    if clk'event and clk='1' then
      en_d1<=en_d0;en_d0<=en;
      if en_d2='1' then
        ce<=not ce;
      end if;
    end if;
  end process;
  en_d2<= not en_d0 and en_d1;
end arch;
