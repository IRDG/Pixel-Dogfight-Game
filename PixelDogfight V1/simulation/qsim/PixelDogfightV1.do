onerror {exit -code 1}
vlib work
vlog -work work PixelDogfightV1.vo
vlog -work work DeleteMe.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.PixelDogfight_vlg_vec_tst -voptargs="+acc"
vcd file -direction PixelDogfightV1.msim.vcd
vcd add -internal PixelDogfight_vlg_vec_tst/*
vcd add -internal PixelDogfight_vlg_vec_tst/i1/*
run -all
quit -f
