library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga_top is
   port(
       clk       : in std_logic;   ----- Input clock
       RESET_n   : in std_logic;   ----- Synchronized active low reset
       O_PULSE   : out std_logic   ----- Output active high pulse of pragrammable duration
   );
end fpga_top;

architecture rtl of fpga_top is

   -- Constants to program the pulse width and pulse period
   constant pulse_width   : natural := 2;
   constant pulse_period  : natural := 3;
   
   -- Signals used to count pulse width and pulse period
   signal counter_width   : natural range 0 to pulse_width;
   signal counter_period  : natural range 0 to pulse_period;
   
begin
   
   pulse_generate : process(clk, RESET_n)
   -- This process generates the active high pulse using the pulse_width and pulse_period
   begin
   
      if(rising_edge(clk)) then
         if(RESET_n = '0') then
            if(counter_period < pulse_period) then
               if(counter_width < pulse_width) then
                  O_PULSE <= '1';
                  -- Update counter value
                  counter_width  <= counter_width + 1;
               else
                  O_PULSE <= '0';
               end if;
               -- Update counter values
               counter_period <= counter_period + 1;
            else
               -- Reset counter values
               counter_width  <= 0;
               counter_period <= 0;
            end if;
         else
            O_PULSE <= '0';
         end if;
      end if;
   end process;
end rtl;