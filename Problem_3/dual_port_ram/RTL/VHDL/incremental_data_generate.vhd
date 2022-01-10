library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incremental_data_generate is
   port(
       clk                        : in std_logic;                ----- Input clock
       reset                      : in std_logic;                ----- Synchronized active high reset
       output_incremental_data    : out std_logic_vector(7 downto 0);   ----- Output serial incremental pattern 8-bit wide
       generator_enable           : out std_logic                ----- Enable signal for generator to start writing data in RAM
   );
end incremental_data_generate;

architecture rtl of incremental_data_generate is

   -- Signals to be used as an 8 bit counter
   signal counter_size    : integer := 256;                                -- Number of values take by counter_main 
   signal counter_main    : integer range 0 to counter_size - 1   := 0;    -- Signal to count from 0 to 255
   signal counter_binary  : std_logic_vector(7 downto 0);                  -- Signal to store the binary value of counter_main
   
begin
   
   -- Convert counter_main to binary and store in counter_binary
   counter_binary <= std_logic_vector(to_unsigned(counter_main, counter_binary'length));
   
   counter_process : process(clk, reset)
   -- This process generates 8-bit serial data after every 8 clock cycles
   -- The 8-bit data is sent serially to the output signal "output_incremental_data"
   begin
      
      if(rising_edge(clk)) then
         if(reset = '0') then
            -- Enable is set high to start writing the RAM
            generator_enable  <= '1';
            
            -- 8-bit counter is used to generate the incremental data
            if(counter_main < counter_size) then
               -- Sending the 8-bit data as output
               output_incremental_data <= counter_binary;
               counter_main            <= counter_main + 1;
               
               -- Resetting the counter_main value
               if(counter_main = counter_size - 1) then
                  counter_main <= 0;
               end if;
            end if;
         else
            generator_enable        <= '0';         -- Enable set low to stop writing the data to RAM
            counter_main            <= 0;           -- Resetting counter_main to zero
            output_incremental_data <= "00000000";  -- Output is all 0s when reset is high
         end if;
      end if;
   end process;
end rtl;