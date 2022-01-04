rm -rf work
vlib work 
../sim/bin/dut_compile_programmable_pulse_generator.sh
vsim work.pulse_generator_tb -gui -do "add log -r sim:/pulse_generator_tb/*;"