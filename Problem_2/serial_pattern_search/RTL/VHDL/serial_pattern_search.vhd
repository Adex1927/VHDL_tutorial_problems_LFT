library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_pattern_search is
   port(
       clk                    : in std_logic;   ----- Input clock
       RESET_n                : in std_logic;   ----- Synchronized active low reset
       OUTPUT_PATTERN_FOUND   : out std_logic   ----- Output pulse which goes high if the pattern is found
   );
end serial_pattern_search;

architecture rtl of serial_pattern_search is

   -- Signals required
   signal input_serial_pattern : std_logic;                 -- Input serial data of the incremental pattern
   
   -- The type "t_states" defines the 6 states required for the state machine for pattern search
   type t_states is (BITS_MATCH_0, BITS_MATCH_1, BITS_MATCH_2, BITS_MATCH_3, BITS_MATCH_4, BITS_MATCH_5);
   signal current_state        : t_states := BITS_MATCH_0;  -- Signal to keep track of the current state
   
   -- Component declaration
   component serial_pattern_generate is
      port(
          clk                        : in std_logic;
          reset_n                    : in std_logic;
          output_incremental_pattern : out std_logic
      );
   end component serial_pattern_generate;
   
begin

   -- Instantiate the component serial_pattern_generate
   serial_pattern_generate_1 : serial_pattern_generate
                               port map(
                                       clk                        => clk,
                                       reset_n                    => RESET_n,
                                       output_incremental_pattern => input_serial_pattern
                               );
   
   pattern_search_state_machine : process(clk)
   -- This process implements the state machine used to search for the sequence "101101"
   -- The incoming bit stream is in the signal input_serial_pattern
   begin
      
      if(rising_edge(clk)) then
         if(RESET_n = '0') then
            -- Set the current state to BITS_MATCH_0 and output pulse to '0' when reset is active
            current_state        <= BITS_MATCH_0;
            OUTPUT_PATTERN_FOUND <= '0';
            
         else
            -- Implementing the state machine using signal "state"
            case current_state is
               when BITS_MATCH_0 =>
                  -- This state shows that 0 bits of the pattern are matched - ""
                  -- If next bit is '0', next state is BITS_MATCH_0
                  -- If next bit is '1', next state is BITS_MATCH_1
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_0;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_1;
                     OUTPUT_PATTERN_FOUND <= '0';
                  end if;
               
               when BITS_MATCH_1 =>
                  -- This state shows that 1 bit of the pattern is matched - "1"
                  -- If next bit is '0', next state is BITS_MATCH_2
                  -- If next bit is '1', next state is BITS_MATCH_1
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_2;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_1;
                     OUTPUT_PATTERN_FOUND <= '0';
                  end if;
                  
               when BITS_MATCH_2 =>
                  -- This state shows that 2 bits of the pattern are matched - "01"
                  -- If next bit is '0', next state is BITS_MATCH_0
                  -- If next bit is '1', next state is BITS_MATCH_3
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_0;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_3;
                     OUTPUT_PATTERN_FOUND <= '0';
                  end if;
                  
               when BITS_MATCH_3 =>
                  -- This state shows that 3 bits of the pattern are matched - "101"
                  -- If next bit is '0', next state is BITS_MATCH_2
                  -- If next bit is '1', next state is BITS_MATCH_4
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_2;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_4;
                     OUTPUT_PATTERN_FOUND <= '0';
                  end if;
                  
               when BITS_MATCH_4 =>
                  -- This state shows that 4 bits of the pattern are matched - "1101"
                  -- If next bit is '0', next state is BITS_MATCH_5
                  -- If next bit is '1', next state is BITS_MATCH_1
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_5;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_1;
                     OUTPUT_PATTERN_FOUND <= '0';
                  end if;
                  
               when BITS_MATCH_5 =>
                  -- This state shows that 5 bits of the pattern are matched - "01101"
                  -- If next bit is '0', next state is BITS_MATCH_0
                  -- If next bit is '1', the entire pattern is matched, and next state is BITS_MATCH_3
                  if(input_serial_pattern = '0') then
                     current_state        <= BITS_MATCH_0;
                     OUTPUT_PATTERN_FOUND <= '0';
                  elsif(input_serial_pattern = '1') then
                     current_state        <= BITS_MATCH_3;
                     OUTPUT_PATTERN_FOUND <= '1'; -- The pattern is matched
                  end if;
                  
               when others =>
                  -- This case takes care of any other value of current state
                  current_state        <= BITS_MATCH_0;
                  OUTPUT_PATTERN_FOUND <= '0';
            end case;
         end if;
      end if;
   end process;
end rtl;