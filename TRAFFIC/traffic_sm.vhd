library ieee;
use ieee.std_logic_1164.all;

entity traffic_sm is
  port (
        clk : in std_logic;
        rst : in std_logic;
        dip : in std_logic_vector(1 downto 0);
	    red1, yellow1, green1 : out std_logic;
	    red2, yellow2, green2 : out std_logic;
	    time1,time2: out std_logic_vector(3 downto 0)
	   );
end traffic_sm;

architecture a of traffic_sm is
  type state is (s0,s1,s2,s3,s4,s5,s6,s7);
  signal present_state,next_state : state;
begin
  process (present_state, dip)
  begin
    red1 <= '1'; yellow1 <= '1'; green1 <= '1';
    red2 <= '1'; yellow2 <= '1'; green2 <= '1';
    time1<= "1111"; time2<="1111";
    case present_state is
	  when s0 =>
	      green1 <= '0';  red2 <= '0';
	      time1<="0011";
	      if dip= "01" then
            next_state <= s0;
          else
            next_state <= s1;
          end if;
      when s1 =>       
          green1 <= '0';  red2 <= '0';
          time1<="0010";
          next_state <= s2;
      when s2 =>
          green1 <= '0';  red2 <= '0';
          time1<="0001";
          next_state <= s3;
      when s3 =>
          yellow1 <= '0'; red2 <= '0';
          time1<="0000";
          next_state <= s4;
      when s4 =>
          red1 <= '0';    green2 <= '0';
          time2<="0011";
          if dip= "10" then
            next_state <= s4;
          else
            next_state <= s5;
          end if;
      when s5 =>
          red1 <= '0';    green2 <= '0';
          time2<="0010";
          next_state <= s6;
      when s6 =>
          red1 <= '0';    green2 <= '0';
          time2<="0001";
          next_state <= s7;
      when s7 =>
          red1 <= '0';    yellow2 <= '0';
          time2<="0000";
          next_state <= s0;
	end case;
  end process;

  process(rst,clk)
  begin
    if (rst='0') then
      present_state <= s0;
    elsif clk'event and clk='1' then
      present_state <= next_state ;
    end if ;
  end process;
end a;
