library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library xpm;
use xpm.vcomponents.all;

entity dual_port_ram is
   port(
       clk                       : in std_logic;   ----- Input clock
       reset                     : in std_logic;   ----- Active high synchronized reset
       output_pulse              : out std_logic   ----- Output pulse which goes high if the checker finds any error in the data
   );
end dual_port_ram;

architecture rtl of dual_port_ram is

   -- Signals for generator
   signal input_incremental_data : std_logic_vector(7 downto 0) := (others => '0');   -- 8-bit signal to get input incremental data
   signal generator_enable       : std_logic                    := '0';               -- Enable signal from generator to control Port A of RAM block
   
   -- Signals for checker
   signal read_address           : std_logic_vector(7 downto 0) := (others => '0');   -- Signal to hold the read address from RAM
   signal output_data            : std_logic_vector(7 downto 0) := (others => '0');   -- Signal to get the read data from RAM 
   signal checker_enable         : std_logic                    := '0';               -- Enable signal from checker to control Port B of RAM block
   
   -- Signals for Port A of True Dual Port RAM
   signal wea     : std_logic_vector(0 downto 0)   := (others => '0');
   signal addra   : std_logic_vector(7 downto 0)   := (others => '0');
   signal dina    : std_logic_vector(7 downto 0)   := (others => '0');
   signal douta   : std_logic_vector(7 downto 0)   := (others => '0');
   
   -- Signals for Port B of True Dual Port RAM
   signal web     : std_logic_vector(0 downto 0)   := (others => '0');
   signal addrb   : std_logic_vector(7 downto 0)   := (others => '0');
   signal dinb    : std_logic_vector(7 downto 0)   := (others => '0');
   signal doutb   : std_logic_vector(7 downto 0)   := (others => '0');
   
   component incremental_data_generate is
      port(
          clk                        : in std_logic;                      ----- Input clock
          reset                      : in std_logic;                      ----- Synchronized active high reset
          output_incremental_data    : out std_logic_vector(7 downto 0);  ----- Output serial incremental pattern 8-bit wide
          generator_enable           : out std_logic                      ----- Enable signal for generator to start writing data in RAM
      );
   end component incremental_data_generate;
   
   component incremental_data_checker is
      port(
          clk                        : in std_logic;                       ----- Input clock
          reset                      : in std_logic;                       ----- Synchronized active high reset
          input_data                 : in std_logic_vector(7 downto 0);    ----- Output serial incremental pattern 8-bit wide
          output_pulse               : out std_logic;                      ----- Output pulse which goes high if any bit is not matching 
          checker_enable             : out std_logic;                      ----- Enable signal for generator to start writing data in RAM
          read_address               : out std_logic_vector(7 downto 0)    ----- Address to read the RAM block
      );
   end component incremental_data_checker;

begin

   -- Instantiate the incremental_data_generate
   incremental_data_generate_1 : incremental_data_generate
                                 port map(
                                          clk                        => clk,
                                          reset                      => reset,
                                          output_incremental_data    => input_incremental_data,
                                          generator_enable           => generator_enable
                                 );
                       
   -- Instantiate the incremental_data_checker
   incremental_data_checker_1 : incremental_data_checker
                             port map(
                                     clk              => clk,
                                     reset            => reset,
                                     input_data       => output_data,
                                     output_pulse     => output_pulse,
                                     checker_enable   => checker_enable,
                                     read_address     => read_address
                             );
                    
   -- Instantiate a True Dual Port RAM block using Language Templates
   -- xpm_memory_tdpram: True Dual Port RAM
   -- Xilinx Parameterized Macro, version 2020.1

   xpm_memory_tdpram_inst : xpm_memory_tdpram
   generic map (
      ADDR_WIDTH_A => 8,               -- DECIMAL
      ADDR_WIDTH_B => 8,               -- DECIMAL
      AUTO_SLEEP_TIME => 0,            -- DECIMAL
      BYTE_WRITE_WIDTH_A => 8,         -- DECIMAL
      BYTE_WRITE_WIDTH_B => 8,         -- DECIMAL
      CASCADE_HEIGHT => 0,             -- DECIMAL
      CLOCKING_MODE => "common_clock", -- String
      ECC_MODE => "no_ecc",            -- String
      MEMORY_INIT_FILE => "none",      -- String
      MEMORY_INIT_PARAM => "0",        -- String
      MEMORY_OPTIMIZATION => "true",   -- String
      MEMORY_PRIMITIVE => "auto",      -- String
      MEMORY_SIZE => 256,              -- DECIMAL
      MESSAGE_CONTROL => 0,            -- DECIMAL
      READ_DATA_WIDTH_A => 8,          -- DECIMAL
      READ_DATA_WIDTH_B => 8,          -- DECIMAL
      READ_LATENCY_A => 2,             -- DECIMAL
      READ_LATENCY_B => 2,             -- DECIMAL
      READ_RESET_VALUE_A => "0",       -- String
      READ_RESET_VALUE_B => "0",       -- String
      RST_MODE_A => "SYNC",            -- String
      RST_MODE_B => "SYNC",            -- String
      SIM_ASSERT_CHK => 0,             -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      USE_EMBEDDED_CONSTRAINT => 0,    -- DECIMAL
      USE_MEM_INIT => 1,               -- DECIMAL
      WAKEUP_TIME => "disable_sleep",  -- String
      WRITE_DATA_WIDTH_A => 8,         -- DECIMAL
      WRITE_DATA_WIDTH_B => 8,         -- DECIMAL
      WRITE_MODE_A => "no_change",     -- String
      WRITE_MODE_B => "no_change"      -- String
   )
   port map (


      douta => douta,                   -- READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      doutb => doutb,                   -- READ_DATA_WIDTH_B-bit output: Data output for port B read operations.


      addra => addra,                   -- ADDR_WIDTH_A-bit input: Address for port A write and read operations.
      addrb => addrb,                   -- ADDR_WIDTH_B-bit input: Address for port B write and read operations.
      clka => clk,                      -- 1-bit input: Clock signal for port A. Also clocks port B when
                                        -- parameter CLOCKING_MODE is "common_clock".

      clkb => clk,                      -- 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                        -- "independent_clock". Unused when parameter CLOCKING_MODE is
                                        -- "common_clock".

      dina => dina,                     -- WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      dinb => dinb,                     -- WRITE_DATA_WIDTH_B-bit input: Data input for port B write operations.
      ena => generator_enable,                       -- 1-bit input: Memory enable signal for port A. Must be high on clock
                                        -- cycles when read or write operations are initiated. Pipelined
                                        -- internally.

      enb => checker_enable,                       -- 1-bit input: Memory enable signal for port B. Must be high on clock
                                        -- cycles when read or write operations are initiated. Pipelined
                                        -- internally.

      injectdbiterra => '0',            -- 1-bit input: Controls double bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      injectdbiterrb => '0',            -- 1-bit input: Controls double bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      injectsbiterra => '0',            -- 1-bit input: Controls single bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      injectsbiterrb => '0',            -- 1-bit input: Controls single bit error injection on input data when
                                        -- ECC enabled (Error injection capability is not available in
                                        -- "decode_only" mode).

      regcea => '1',                    -- 1-bit input: Clock Enable for the last register stage on the output
                                        -- data path.

      regceb => '1',                    -- 1-bit input: Clock Enable for the last register stage on the output
                                        -- data path.

      rsta => '0',                      -- 1-bit input: Reset signal for the final port A output register
                                        -- stage. Synchronously resets output port douta to the value specified
                                        -- by parameter READ_RESET_VALUE_A.

      rstb => '0',                      -- 1-bit input: Reset signal for the final port B output register
                                        -- stage. Synchronously resets output port doutb to the value specified
                                        -- by parameter READ_RESET_VALUE_B.

      sleep => '0',                     -- 1-bit input: sleep signal to enable the dynamic power saving feature.
      wea => wea,                       -- WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                        -- for port A input data port dina. 1 bit wide when word-wide writes
                                        -- are used. In byte-wide write configurations, each bit controls the
                                        -- writing one byte of dina to address addra. For example, to
                                        -- synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                        -- is 32, wea would be 4'b0010.

      web => web                        -- WRITE_DATA_WIDTH_B/BYTE_WRITE_WIDTH_B-bit input: Write enable vector
                                        -- for port B input data port dinb. 1 bit wide when word-wide writes
                                        -- are used. In byte-wide write configurations, each bit controls the
                                        -- writing one byte of dinb to address addrb. For example, to
                                        -- synchronously write only bits [15-8] of dinb when WRITE_DATA_WIDTH_B
                                        -- is 32, web would be 4'b0010.

   );
   -- End of xpm_memory_tdpram_inst instantiation    
                        
   write_ram_port_a : process(clk, reset)
   -- This process is used for writing data into the True Dual Port RAM block
   -- The wea signal is set high to enable writing at Port A
   -- The data is written only after the enable signal is set high by the generator and the reset is de-asserted
   begin
      
      if(rising_edge(clk)) then
         if(reset = '0' and generator_enable = '1') then
            -- Writing data through port A
            wea   <= "1";                       -- Write enable is set high for Port A
            addra <= input_incremental_data;    -- Address is same as the incremental data
            dina  <= input_incremental_data;    -- The incremental data is given as input at Port A
         else
            wea   <= "0";                       -- Write enable is set low if reset is asserted or Port is not enabled
         end if;
      end if;
   end process;
   
   -- The data is read from the RAM block using Port BYTE_WRITE_WIDTH_A
   -- The "checker_enable" signal controls the Port B by turning it high after 2 cycles from reset de-assertion
   -- The address to read from is same as the incremental data, provided by "read_address" signal
   -- The "output_data" signal is connected to "doutb" of the RAM block for the checker to perform comparisons
   addrb       <= read_address;
   output_data <= doutb;

end rtl;