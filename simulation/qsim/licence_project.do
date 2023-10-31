onerror {quit -f}
vlib work
vlog -work work licence_project.vo
vlog -work work licence_project.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.licence_project_vlg_vec_tst
vcd file -direction licence_project.msim.vcd
vcd add -internal licence_project_vlg_vec_tst/*
vcd add -internal licence_project_vlg_vec_tst/i1/*
add wave /*
run -all
