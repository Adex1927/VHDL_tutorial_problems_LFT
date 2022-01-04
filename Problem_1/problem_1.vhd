library ieee;
use ieee.std_logic_1164.all;

entity fpga_top is
   port (
        clk       : in std_logic;   ----- Input clock
		RESET_n   : in std_logic;   ----- Async active low reset
		O_PULSE   : out std_logic   ----- Output active high pulse of pragrammable duration
  );
end fpga_top;

architecture rtl of fpga_top is

   -- constants to program the pulse width and pulse period
   pulse_width   : natural := 5;
   pulse_period  : natural := 12;
   
   