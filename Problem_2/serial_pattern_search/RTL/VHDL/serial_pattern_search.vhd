library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_pattern_search is
   port(
       clk                    : in std_logic;   ----- Input clock
       OUTPUT_PATTERN_FOUND   : out std_logic   ----- Output pulse which goes high if the pattern is found
   );
end serial_pattern_search;

architecture rtl of serial_pattern_search is

   -- Signals required
   signal input_serial_pattern : std_logic;  -- Input serial data of the incremental pattern
   
   -- Component declaration
   component serial_pattern_generate is
      port(
          clk                        : in std_logic;
          output_incremental_pattern : out std_logic
      );
   end component serial_pattern_generate;
   
begin

   -- Instantiate the component serial_pattern_generate
   serial_pattern_generate_1 : serial_pattern_generate
                               port map(
                                       clk                        => clk,
                                       output_incremental_pattern => input_serial_pattern
                               );
   
   -- for testing pattern generator
   OUTPUT_PATTERN_FOUND <= input_serial_pattern;
   
end rtl;