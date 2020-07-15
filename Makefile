all:
	verilator -Wall -sc tb.sv mux.sv --top-module tb
	make -j -C obj_dir -f Vtb.mk Vtb__ALL.a
	make -j -C obj_dir -f Vtb.mk ../sc_main.o verilated.o
	cd obj_dir/ && g++ ../sc_main.o Vtb__ALL.a verilated.o -o Vtb -lsystemc
	obj_dir/Vtb 
