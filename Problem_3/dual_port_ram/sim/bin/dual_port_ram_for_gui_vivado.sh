#######################################################################################################################
##Starting of Cleaning and Compilation
#export XILINX=C:/Xilinx/14.7/ISE_DS/ISE
#export PLATFORM=nt64
#export PATH=$PATH:${XILINX}/bin/${PLATFORM}

    export XILINX_VIVADO=C:/Xilinx/Vivado/2020.1
    chmod -fR 777 *
	
	rm -rf *.jou
	rm -rf *.log
	rm -rf xsim.dir
	rm -rf .Xil
	rm -rf xelab.pb
	rm -rf test.wdb
   
    if [ ! -d "result" ]; then
        mkdir result
    fi
    
	if [ ! -d "log" ]; then
       mkdir log
    fi    


#fuse work.fpga_top_tb -generic_top "TESTCASE=$1" -generic_top "SUB_TEST=$2" -generic_top "PPI_TX_CLK_MODE=$5" -generic_top "PPI_RX_CLK_MODE=$6" -generic_top "LW=$7" -generic_top "DIGRF_CLK_MODE=$8" -prj bin/ukko_top_isim.prj -o ukko_top_isim.exe

#fuse work.fpga_top_tb -L unisims_ver -L xilinxcorelib -prj bin/istrac_top.prj -o istrac_top.exe
#./istrac_top.exe -gui
#export PATH=$PATH:C:\Xilinx\Vivado\2016.2\bin\unwrapped\win64.o

#rm -rf xsim.dir
xelab -timescale 1ns/1ps -prj bin/dual_port_ram_vivado.prj -L XPM -L building_blocks -debug all -s test work.dual_port_ram_tb
     
      
#xelab -timescale 1ps/1ps -prj programmable_pulse_generator_vivado.prj -L unisim -L unisims_ver -L xilinxcorelib -L xilinxcorelib_ver -L unimacro -L unimacro_ver -L simprims_ver -L secureip -L uni9000_ver glbl -L xpm -debug all -s test work.TEST_incremental_data_store
 xsim -g test
# get_files -compile_order sources -used_in simulation -of_objects [get_files axi_interconnect_0.xci]

