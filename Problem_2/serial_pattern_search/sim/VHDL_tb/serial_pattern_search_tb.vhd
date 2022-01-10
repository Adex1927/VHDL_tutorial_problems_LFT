library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_pattern_search_tb is
end serial_pattern_search_tb;

architecture behave of serial_pattern_search_tb is

   -- Clock frequency = 10 MHz
   constant clock_period : time := 100 ns;
   
   -- Signal to stimulate clock and get output pulse
   signal i_clk   : std_logic := '1';
   signal reset_n : std_logic := '0';
   signal o_pulse : std_logic := '0';
   
   -- Component declaration
   component serial_pattern_search is
      port(
          clk                    : in std_logic;
          RESET_n                : in std_logic;
          OUTPUT_PATTERN_FOUND   : out std_logic
      );
   end component serial_pattern_search;
   
begin

   -- Instantiate the unit under test
   UUT : serial_pattern_search
         port map(
                 clk                  => i_clk,
                 RESET_n              => reset_n,
                 OUTPUT_PATTERN_FOUND => o_pulse
         );
         
   generate_clock : process is
   -- This process generates a clock signal using the clock_period
   begin
      wait for clock_period/2;
      i_clk <= not i_clk;
   end process generate_clock;
   
   process
   -- This process performs the testing of the component pulse_generator
   begin
      reset_n <= '0';
      wait for 1 us;
      
      reset_n <= '1';
      wait;
   end process;
end behave;