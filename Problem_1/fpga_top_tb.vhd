library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga_top_tb is
end fpga_top_tb;

architecture behave of fpga_top_tb is

   -- Clock frequency = 10 MHz
   constant clock_period : time := 100 ns;
   
   -- Signal to stimulate clock and reset
   signal i_clk   : std_logic := '1';
   signal reset_n : std_logic := '1';
   signal o_pulse : std_logic := '0';
   
   -- Component declaration
   component fpga_top is
      port(
          clk       : in std_logic;
          RESET_n   : in std_logic;
          O_PULSE   : out std_logic
      );
   end component fpga_top;
   
begin

   -- Instantiate the unit under test
   UUT : fpga_top
         port map(
                 clk     => i_clk,
                 RESET_n => reset_n,
                 O_PULSE => o_pulse
         );
   
   generate_clock : process is
   -- This process generates a clock signal using the clock_period
   begin
      wait for clock_period/2;
      i_clk <= not i_clk;
   end process generate_clock;
   
   process
   -- This process performs the testing of the component fpga_top
   begin
      
      reset_n <= '1';
      wait for 200 ns;
      
      reset_n <= '0';
      wait for 12000 ns;
      
   end process;
end behave;