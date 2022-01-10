library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_generator_tb is
end pulse_generator_tb;

architecture behave of pulse_generator_tb is

   -- Constants to run simulation
   constant clock_period      : time    := 100 ns;   -- Clock frequency = 10 MHz
   constant sim_pulse_width   : integer := 7;
   constant sim_pulse_period  : integer := 13;
   
   -- Signal to stimulate clock and reset
   signal i_clk   : std_logic := '1';
   signal reset_n : std_logic := '1';
   signal o_pulse : std_logic := '0';
   
   -- Component declaration
   component pulse_generator is
      generic(
             pulse_width   : integer := 5;
             pulse_period  : integer := 12
      );
      port(
          clk            : in std_logic;
          RESET_n        : in std_logic;
          OUTPUT_PULSE   : out std_logic
      );
   end component pulse_generator;
   
begin

   -- Instantiate the unit under test
   UUT : pulse_generator
         generic map(
                    pulse_width  => sim_pulse_width,
                    pulse_period => sim_pulse_period
         )
         port map(
                 clk          => i_clk,
                 RESET_n      => reset_n,
                 OUTPUT_PULSE => o_pulse
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
      
      reset_n <= '1';
      wait for 200 ns;
      
      reset_n <= '0';
      wait for 3000 ns;
      
      reset_n <= '1';
      wait for 500 ns;
      
      reset_n <= '0';
      wait for 3000 ns;
      
      reset_n <= '1';
      wait for 150 ns;
      
      reset_n <= '0';
      wait for 3000 ns;
      
   end process;
end behave;