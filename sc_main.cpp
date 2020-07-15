#include "Vtb.h"
int sc_main(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
 // sc_set_time_resolution (1.0, SC_US);
  sc_clock clk ("clk", 10, 0.5, 3, true);
  Vtb* top;
  top = new Vtb("top");
  top->clk(clk);
  while (!Verilated::gotFinish()) { sc_start(1, SC_NS); }
  delete top;
  exit(0);
}											      
