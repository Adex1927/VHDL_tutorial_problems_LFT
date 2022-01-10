library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incremental_data_checker is
   port(
       clk                        : in std_logic;                      ----- Input clock
       reset                      : in std_logic;                      ----- Synchronized active high reset
       input_data                 : in std_logic_vector(7 downto 0);   ----- Output serial incremental pattern 8-bit wide
       output_pulse               : out std_logic;                     ----- Output pulse which goes high if any bit is not matching 
       checker_enable             : out std_logic;                     ----- Enable signal for generator to start writing data in RAM
       read_address               : out std_logic_vector(7 downto 0)   ----- Address to read the RAM block
   );
end incremental_data_checker;

architecture rtl of incremental_data_checker is

   signal counter : integer range 0 to 5 := 0;   -- Counter to keep track of the delay for the checker to work
   signal enable  : std_logic := '0';            -- Enable signal to control the working of Port B of RAM block
   
   -- Signals to be used as an 8 bit counter
   signal counter_size    : integer := 256;                                             -- Number of values take by counter_main 
   signal counter_main    : integer range 0 to counter_size - 1   := 0;                 -- Signal to count from 0 to 255
   signal counter_binary  : std_logic_vector(7 downto 0)          := (others => '0');   -- Signal to store the binary value of counter_main
   signal compare_binary  : std_logic_vector(7 downto 0)          := (others => '0');   -- Signal to store the binary value of counter_main-3
   
begin
   
   checker_enable <= enable;  -- Assign the enable signal
   
   -- Convert counter_main to binary and store in counter_binary
   counter_binary <= std_logic_vector(to_unsigned(counter_main, counter_binary'length));
   
   -- Convert (counter_main - 3) to binary as the data read from RAM block is delayed
   compare_binary <= std_logic_vector(to_unsigned((counter_main-3), counter_binary'length));
   
   counter_process : process(clk, reset)
   -- This process generates 8-bit serial data after every 8 clock cycles
   -- The 8-bit data is started to generate only after 2 cycles after Reset is de-asserted
   begin
      
      if(rising_edge(clk)) then
         if(reset = '0' and counter > 1) then
            
            -- 8-bit counter is used to generate the incremental data
            if(counter_main < counter_size) then
               counter_main            <= counter_main + 1;
               
               -- Resetting the counter_main value
               if(counter_main = counter_size - 1) then
                  counter_main <= 0;
               end if;
            end if;
         else
            counter_main   <= 0;           -- Resetting counter_main to zero
         end if;
      end if;
   end process;
   
   checker_process : process(clk, reset)
   -- This process enables the Port B on the RAM block after 2 cycles of reset de-assertion
   -- The address to read the data is provided by counter_binary
   -- The data read is compared with compare_binary which is a delayed version of counter_binary
   -- The comparison is done bit-wise. If any bit is different, the output_pulse goes high
   -- The comparison is stared after counter > 4 to keep track of data reading delays
   begin
      
      if(rising_edge(clk)) then
         if(reset = '0') then
            if(counter > 1) then
               enable         <= '1';              -- Enable is set high to start reading the RAM
               read_address   <= counter_binary;   -- Address provided for reading the RAM block
            
            else
               counter <= counter + 1;             -- Updating the counter to keep track of delay cycles
            end if;
            
            if(counter > 4) then
               -- We compare the data read from the RAM block to the data generated
               -- Generate output by XORing all corresponding bits
               output_pulse <= (compare_binary(0) xor input_data(0)) or
                               (compare_binary(1) xor input_data(1)) or
                               (compare_binary(2) xor input_data(2)) or
                               (compare_binary(3) xor input_data(3)) or
                               (compare_binary(4) xor input_data(4)) or
                               (compare_binary(5) xor input_data(5)) or
                               (compare_binary(6) xor input_data(6)) or
                               (compare_binary(7) xor input_data(7));
            else
               counter <= counter + 1;             -- Updating the counter to keep track of delay cycles
            end if;
         else
            enable        <= '0';         -- Enable set 0 to stop writing the data to RAM  
            read_address  <= "00000000";  -- Read address is initialized to all 0s
            output_pulse  <= '0';         -- Output is 0 when reset is high
            counter       <= 0;           -- Counter is initialized to 0
         end if;
      end if;
   end process;
end rtl;