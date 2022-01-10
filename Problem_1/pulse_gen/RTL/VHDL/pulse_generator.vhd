library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_generator is
   generic(
          pulse_width   : integer := 5;   ----- Generic value to define pulse width
          pulse_period  : integer := 12   ----- Generic value to define pulse period
   );
   port(
       clk            : in std_logic;   ----- Input clock
       RESET_n        : in std_logic;   ----- Synchronized active low reset
       OUTPUT_PULSE   : out std_logic   ----- Output active high pulse of pragrammable duration
   );
end pulse_generator;

architecture rtl of pulse_generator is
   
   -- Signals used to count pulse width and pulse period
   signal counter_width   : integer range 0 to pulse_width;
   signal counter_period  : integer range 0 to pulse_period;
   
begin
   
   pulse_generate : process(clk, RESET_n)
   -- This process generates the active high pulse using the pulse_width and pulse_period values
   -- The pulse stays high while counter_width counts up to pulse_width
   -- The pulse becomes low after counter_width becomes equal to pulse_width, upto the pulse_period
   -- The OUTPUT_PULSE signal becomes low when RESET_n is high
   -- The OUTPUT_PULSE signal gets the programmed pulse starting from high, when the RESET_n is set low
   -- The RESET_n has assertion and de-assertion synchronized with the clock
   begin
   
      if(rising_edge(clk)) then
         if(RESET_n = '0') then
            if(counter_period < pulse_period) then
               if(counter_width < pulse_width) then
                  OUTPUT_PULSE   <= '1';
                  -- Update counter_width value
                  counter_width  <= counter_width + 1;
               else
                  OUTPUT_PULSE <= '0';
               end if;
               -- Update counter_period values
               counter_period <= counter_period + 1;
            else
               OUTPUT_PULSE   <= '1';   -- To continue the pulse in the next pulse cycle
               -- Reset counter values to 1 to contunue to the next pulse cycle
               counter_width  <= 1;
               counter_period <= 1;
            end if;
         else
            -- When RESET_n is de-asserted, OUTPUT_PULSE is set to low
            OUTPUT_PULSE   <= '0';
            -- Counters are set to 0 to restart the pulse when RESET_n is asserted
            counter_period <= 0;
            counter_width  <= 0;
         end if;
      end if;
   end process;
end rtl;