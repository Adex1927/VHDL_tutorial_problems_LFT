library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_pattern_generate is
   port(
       clk                        : in std_logic;   ----- Input clock
       output_incremental_pattern : out std_logic   ----- Output serial incremental pattern 8-bit wide
   );
end serial_pattern_generate;

architecture rtl of serial_pattern_generate is

   -- Signals to be used as an 8 bit counter
   signal counter_bitsize : integer := 8;                   -- Bit size of the counter
   signal counter_size    : integer := 256;                 -- Number of values take by counter_main 
   signal counter_main    : integer := 0;                   -- Signal to count from 0 to 255
   signal counter_bits    : integer := 0;                   -- Signal to count from 0 to 7
   signal counter_binary  : std_logic_vector(7 downto 0);   -- Signal to store the binary value of counter_main
   
begin
   
   -- Convert counter_main to binary and store in counter_binary
   counter_binary <= std_logic_vector(to_unsigned(counter_main, counter_binary'length));
   
   counter_process : process(clk)
   -- This process generates 8-bit serial data after every 8 clock cycles
   -- The 8-bit data is sent serially to the output signal "output_incremental_pattern"
   begin
      
      if(rising_edge(clk)) then
         if(counter_main < counter_size) then
            if(counter_bits < counter_bitsize) then
               -- Output the 8-bit data serially
               output_incremental_pattern <= counter_binary(counter_bits);
               
               -- Resetting the counter_bits value and updating counter_main value
               if(counter_bits = counter_bitsize - 1) then
                  counter_bits <= 0;
                  counter_main <= counter_main + 1;
                 
               else
                  counter_bits <= counter_bits + 1;
               end if;
            end if;
            
            -- Resetting the counter_main value
            if(counter_main = counter_size - 1) then
               counter_main <= 0;
            end if;
         end if;
      end if;
   end process;
end rtl;