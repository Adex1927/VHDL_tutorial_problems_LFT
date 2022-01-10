library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_ram_tb is
end dual_port_ram_tb;

architecture behave of dual_port_ram_tb is
   
   -- Clock frequency = 10 MHz
   constant clock_period : time := 100 ns;
   
   -- Signal to stimulate clock and get output pulse
   signal i_clk   : std_logic := '1';
   signal reset   : std_logic := '1';
   signal o_pulse : std_logic := '1';
   
   -- Component declaration
   component dual_port_ram is
      port(
          clk                       : in std_logic;   ----- Input clock
          reset                     : in std_logic;    ----- Active high synchronized reset
          output_pulse              : out std_logic
      );
   end component dual_port_ram;
begin

   -- Instantiate the unit under test
   UUT : dual_port_ram
         port map(
                 clk                  => i_clk,
                 reset                => reset,
                 output_pulse         => o_pulse
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
      reset <= '1';
      wait for 1 us;
      
      reset <= '0';
      wait;
   end process;
end behave;