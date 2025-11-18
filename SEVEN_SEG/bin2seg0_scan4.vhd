library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------------------------------------------------------------
--DESCRIPTION : binary to 7segment with scan function decoder(active low '0')
--FILE NAME   : bin2seg0_scan.vhd

--  a <= seg(0);
--  b <= seg(1);
--  c <= seg(2);
--  d <= seg(3);
--  e <= seg(4);
--  f <= seg(5);
--  g <= seg(6);
----------------------------------------------------------------------------

entity bin2seg0_scan4 is
  port (
         clk       : in  std_logic;                    --64hz clock
         rst       : in  std_logic;                    --segment enable
         q_mone     : in  std_logic_vector(3 downto 0); --binary input of one
         q_mten     : in  std_logic_vector(3 downto 0); --binary input of ten
         q_sone     : in  std_logic_vector(3 downto 0); --binary input of one
         q_sten     : in  std_logic_vector(3 downto 0); --binary input of ten
         seg_out   : out std_logic_vector(6 downto 0); --7segment output
         seg_mone  : out std_logic;                    --7segment one enable
         seg_mten  : out std_logic;                    --7segment ten enable
         seg_sone  : out std_logic;                    --7segment one enable
         seg_sten  : out std_logic                     --7segment ten enable
        );
end bin2seg0_scan4;

architecture arch of bin2seg0_scan4 is

---------SIGNAL DECLARED----------------------------------------------------
signal bin: std_logic_vector(3 downto 0);  --binary code
signal sel: integer range 0 to 3;          --scan coutnter
begin

-----------PROGRAM BODY-----------------------------------------------------
----------scan and signal assign----------
  process (clk,rst)
  begin
    if rst='0' then
      seg_sone<='0';
      seg_sten<='0';
      seg_mone<='0';
      seg_mten<='0';
      sel<=0;
    elsif clk'event and clk='1' then
      sel<=sel+1;
      case sel is
        when 0 =>
          bin<=q_sone;
          seg_sone<='1';
          seg_sten<='0';
          seg_mone<='0';
          seg_mten<='0';
        when 1 =>
          bin<=q_sten;
          seg_sone<='0';
          seg_sten<='1';
          seg_mone<='0';
          seg_mten<='0';
        when 2 =>
          bin<=q_mone;
          seg_sone<='0';
          seg_sten<='0';
          seg_mone<='1';
          seg_mten<='0';
        when 3 =>
          bin<=q_mten;
          seg_sone<='0';
          seg_sten<='0';
          seg_mone<='0';
          seg_mten<='1';
        when others =>
          null;
      end case;
  end if;
end process;

----------binary to seven segment decoder----------
  process (bin)
  begin
    case bin is
      when "0000" => seg_out <= "1000000";  -- 0   active low '0'
      when "0001" => seg_out <= "1111001";  -- 1
      when "0010" => seg_out <= "0100100";  -- 2
      when "0011" => seg_out <= "0110000";  -- 3
      when "0100" => seg_out <= "0011001";  -- 4
      when "0101" => seg_out <= "0010010";  -- 5
      when "0110" => seg_out <= "0000010";  -- 6
      when "0111" => seg_out <= "1111000";  -- 7
      when "1000" => seg_out <= "0000000";  -- 8
      when "1001" => seg_out <= "0010000";  -- 9
      when others => seg_out <= "1111111";   
    end case;
  end process;
      
end arch;
