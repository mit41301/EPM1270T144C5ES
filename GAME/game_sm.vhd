library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game_sm is
  port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        sw2,sw3 : in  std_logic;
        dip1    : in  std_logic;
        min_ten : out std_logic_vector(3 downto 0);
        min_one : out std_logic_vector(3 downto 0);
        sec_ten : out std_logic_vector(3 downto 0);
        sec_one : out std_logic_vector(3 downto 0);
        led_sel : out std_logic_vector(1 downto 0)
      );
end game_sm;

architecture a of game_sm is
  type state_type is (S0,S1,S2);
  signal present_state,next_state : state_type;
  signal cnta1,cnta2,cntb1,cntb2 : std_logic_vector(3 downto 0);
  signal randoma,randomb:std_logic;
begin
  min_ten<=cnta2;min_one<=cnta1;
  sec_ten<=cntb2;sec_one<=cntb1;

  process(present_state,rst,sw2,sw3,dip1)
  begin
    case present_state is
      when S0 =>
              randoma<='1';randomb<='1';
              led_sel<="01";
              if sw2='0' then
                next_state<=S1;
              else
                next_state<=S0;
              end if;
       when S1 =>
              randoma<='0';randomb<='1';
              led_sel<="01";
              if sw3='0' then
                next_state<=S2;
              else
                next_state<=S1;
              end if;
       when S2 =>
              randoma<='0';randomb<='0';
              if rst='0' then
                next_state<=S0;
              else
                next_state<=S2;
              end if;
              if dip1='1' then
                if cnta2>cntb2 then
                  led_sel<="10";
                elsif cnta2=cntb2 and cnta1>cntb1 then
                  led_sel<="10";
                else
                  led_sel<="00";
                end if;
              else
                if cntb2>cnta2 then
                  led_sel<="10";
                elsif cntb2=cnta2 and cntb1>cnta1 then
                  led_sel<="10";
                else
                  led_sel<="00";
                end if;
              end if;
    end case;
  end process;
  
  process(clk,rst)
  begin
    if rst='0' then
      present_state<=S0;
    elsif clk'event and clk='1' then
      present_state<=next_state;
    end if;
  end process; 
  
  process(clk,randoma)
  begin
    if clk'event and clk='1' then
      if randoma='1' then
        if cnta2 = "1001" then
          if cnta1 = "1001" then
            cnta1 <= "0000";
            cnta2 <= "0000";
          else
            cnta1 <= cnta1 + 1;
          end if;
        elsif cnta1 = "1001" then
          cnta1 <= "0000";
          cnta2 <= cnta2 + 1;
        else
          cnta1 <= cnta1 + 1;
        end if;
      end if;
    end if;
  end process;

  process(clk,randomb)
  begin
    if clk'event and clk='1' then
      if randomb='1' then
        if cntb2 = "1001" then
          if cntb1 = "1001" then
            cntb1 <= "0000";
            cntb2 <= "0000";
          else
            cntb1 <= cntb1 + 1;
          end if;
        elsif cntb1 = "1001" then
          cntb1 <= "0000";
          cntb2 <= cntb2 + 1;
        else
          cntb1 <= cntb1 + 1;
        end if;
      end if;
    end if;
  end process;
end a;
