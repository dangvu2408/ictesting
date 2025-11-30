onerror {exit -code 1}
vlib work
vlog -work work tx_uart.vo
vlog -work work Waveform.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.tx_uart_vlg_vec_tst
vcd file -direction tx_uart.msim.vcd
vcd add -internal tx_uart_vlg_vec_tst/*
vcd add -internal tx_uart_vlg_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f

