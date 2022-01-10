rm -rf work
vlib work 
../sim/bin/dut_compile_programmable_pulse_generator.sh
vsim work.serial_pattern_search_tb -gui -do "add log -r sim:/serial_pattern_search_tb/*;"