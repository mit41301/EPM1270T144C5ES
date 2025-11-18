library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity uart is
port(
     clk       : in  std_logic;
     rst_n     : in  std_logic;
     sel       : in  std_logic_vector(2 downto 0);
     rxd       : in  std_logic;
     rxd_readyH: out std_logic;
     rxd_data  : out std_logic_vector(7 downto 0);
     txd_startH: in  std_logic;
     DBUS      : in  std_logic_vector(7 downto 0);
     txd_doneH : out std_logic;
     txd       : out std_logic
    );
end uart;

architecture a of uart is
  component br_gen
  generic(divisor: integer := 3);
  port(
       sysclk:in std_logic;                   
       sel   :in std_logic_vector(2 downto 0);
       bclkX8:buffer std_logic;                
       bclk  :out std_logic                    
      );
  end component;

  component uart_receiver
  port(
       sysclk    :in  std_logic;         
       rst_n     :in  std_logic;           
       bclkx8    :in  std_logic;          
       rxd       :in  std_logic;                
       rxd_readyH:out std_logic;                
       RDR       :out std_logic_vector(7 downto 0)
      );
  end component;
  
  component uart_transmitter
  port(
       sysclk     : in std_logic; 
       rst_n      : in std_logic;  
       bclk       : in std_logic;  
       txd_startH : in std_logic;  
       DBUS       : in std_logic_vector(7 downto 0);
       txd_doneH  : out std_logic; 
       txd        : out std_logic  
      );
  end component;
  signal bclkx8,bclk: std_logic;
begin
  u1: br_gen generic map(26)
             port map(clk,sel,bclkx8,bclk);
  u2: uart_receiver
             port map(clk,rst_n,bclkx8,rxd,rxd_readyH,rxd_data);
  u3: uart_transmitter
             port map(clk,rst_n,bclk,txd_startH,DBUS,txd_doneH,txd);
end a;
