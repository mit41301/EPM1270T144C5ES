library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_sm is
  port(
       clk1    : in  std_logic;
       clk2    : in  std_logic;
       rst     : in  std_logic;
       sw1     : in  std_logic;
       sw2     : in  std_logic;
       sw3     : in  std_logic;
       sw4     : in  std_logic;
       seg_en  : out std_logic;
       min_ten :out std_logic_vector(3 downto 0);
       min_one :out std_logic_vector(3 downto 0);
       sec_ten :out std_logic_vector(3 downto 0);
       sec_one :out std_logic_vector(3 downto 0)
      );
end clock_sm;

architecture arch of clock_sm is
  type state_type is (reset,pause,start,set_d1,set_d2,set_d3,set_d4);
  signal present_state,next_state : state_type;
  signal cnt_min_one,cnt_min_ten:std_logic_vector(3 downto 0);
  signal cnt_sec_one,cnt_sec_ten:std_logic_vector(3 downto 0);
  signal sw3_d0,sw3_d1,sw3_d2: std_logic;
  signal sw4_d0,sw4_d1,sw4_d2: std_logic;
  signal clk2_d0,clk2_d1,clk2_d2: std_logic;
begin
  seg_en<='1';
  sw3_d2<=sw3_d1 and not sw3_d0;
  sw4_d2<=sw4_d1 and not sw4_d0;
  clk2_d2<=not clk2_d1 and clk2_d0;

  process(present_state)
  begin
    case present_state is
      when reset  =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d1;
                    else  next_state<=reset;
                    end if;    
      when pause  =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d1;
                    elsif sw1='0' then next_state<=reset;
                    else  next_state<=pause;
                    end if;
      when start => if    sw3_d2='1' then next_state<=set_d1;
                    elsif sw4='0' then next_state<=pause;
                    elsif sw1='0' then next_state<=reset;
                    else  next_state<=start;
                    end if;
      when set_d1 =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d2;
                    else  next_state<=set_d1;
                    end if;
      when set_d2 =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d3;
                    else  next_state<=set_d2;
                    end if;
      when set_d3 =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d4;
                    else  next_state<=set_d3;
                    end if;
      when set_d4 =>if    sw2='0' then next_state<=start;
                    elsif sw3_d2='1' then next_state<=set_d1;
                    else  next_state<=set_d4;
                    end if;
    end case;
  end process;

  process(clk1,rst)
  begin
    if rst='0' then
      present_state<=reset;
    elsif clk1'event and clk1='1' then
      present_state<=next_state;
      sw3_d1<=sw3_d0;sw3_d0<=sw3;
      sw4_d1<=sw4_d0;sw4_d0<=sw4;
      clk2_d1<=clk2_d0;clk2_d0<=clk2;
    end if;
  end process;

  process(clk1)
  begin
    if clk1'event and clk1='1' then
      case present_state is
        when reset =>
          min_ten<="0000";min_one<="0000";
          sec_ten<="0000";sec_one<="0000";
          cnt_min_ten<="0000"; cnt_min_one<="0000";
          cnt_sec_ten<="0000"; cnt_sec_one<="0000";
        when pause  =>
          min_ten<=cnt_min_ten;min_one<=cnt_min_one;
          sec_ten<=cnt_sec_ten;sec_one<=cnt_sec_one;
        when start =>
          if clk2_d2='1' then
            if cnt_sec_one="1001" then
              if cnt_sec_ten="0101" then
                if cnt_min_one="1001" then
                  if cnt_min_ten="0101" then
                    cnt_min_ten<="0000";cnt_min_one<="0000";
                    cnt_sec_ten<="0000";cnt_sec_one<="0000";
                  else
                    cnt_min_ten<=cnt_min_ten+1;cnt_min_one<="0000";
                    cnt_sec_ten<="0000";cnt_sec_one<="0000";
                  end if;
                else
                  cnt_min_one<=cnt_min_one+1;
                  cnt_sec_ten<="0000";cnt_sec_one<="0000";
                end if;
              else
                cnt_sec_ten<=cnt_sec_ten+1;
                cnt_sec_one<="0000";
              end if;
            else
              cnt_sec_one<=cnt_sec_one+1;
            end if;
          end if;
          min_ten<=cnt_min_ten;min_one<=cnt_min_one;
          sec_ten<=cnt_sec_ten;sec_one<=cnt_sec_one;
        when set_d1=>
          if sw4_d2='1' then
            if cnt_min_ten = 5 then cnt_min_ten <= "0000";
            else cnt_min_ten <= cnt_min_ten + 1;
            end if;
          end if;
          min_ten<=cnt_min_ten;min_one<="1111";
          sec_ten<="1111";sec_one<="1111";
        when set_d2=>
          if sw4_d2='1' then
            if cnt_min_one = 9 then cnt_min_one <= "0000";
            else cnt_min_one <= cnt_min_one + 1;
            end if;
          end if;
          min_ten<="1111";min_one<=cnt_min_one;
          sec_ten<="1111";sec_one<="1111";
        when set_d3=>
          if sw4_d2='1' then
            if cnt_sec_ten = 5 then cnt_sec_ten <= "0000";
            else cnt_sec_ten <= cnt_sec_ten + 1;
            end if;
          end if;
          min_ten<="1111";min_one<="1111";
          sec_ten<=cnt_sec_ten;sec_one<="1111";
        when set_d4=>
          if sw4_d2='1' then
            if cnt_sec_one = 9 then cnt_sec_one <= "0000";
            else cnt_sec_one <= cnt_sec_one + 1;
            end if;
          end if;
          min_ten<="1111";min_one<="1111";
          sec_ten<="1111";sec_one<=cnt_sec_one;
      end case;
    end if;
  end process;
end arch;
