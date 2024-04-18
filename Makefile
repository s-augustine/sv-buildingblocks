compile:
	verilator -Wall -sc axi_trim_tb.sv axi_trim.sv --top-module tb
run:
	make -j -C obj_dir -f Vtb.mk Vtb__ALL.a
	make -j -C obj_dir -f Vtb.mk ../sc_main.o verilated.o
	cd obj_dir/ && g++ ../sc_main.o Vtb__ALL.a verilated.o -o Vtb -lsystemc
	obj_dir/Vtb 
clean:
	rm -rf obj_dir sc_main.o sc_main.d

