vlib work
vlog -f list.f -sv +cover
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -coverage
run 0
add wave /top/ifc/*

#coverage save ram.ucdb -onexit
run -all