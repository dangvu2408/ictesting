onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testtraffic/clk
add wave -noupdate /testtraffic/rst_n
add wave -noupdate /testtraffic/sensor
add wave -noupdate /testtraffic/light_h
add wave -noupdate /testtraffic/light_n
add wave -noupdate /testtraffic/traffic_controller/car
add wave -noupdate /testtraffic/traffic_controller/Timeout
add wave -noupdate /testtraffic/traffic_controller/timeout
add wave -noupdate /testtraffic/traffic_controller/start
add wave -noupdate /testtraffic/traffic_controller/start_h
add wave -noupdate /testtraffic/traffic_controller/start_n
add wave -noupdate /testtraffic/traffic_controller/enable_h
add wave -noupdate /testtraffic/traffic_controller/enable_n
add wave -noupdate -radix decimal /testtraffic/traffic_controller/timer/counter
add wave -noupdate -radix symbolic /testtraffic/traffic_controller/highway_controller/CurrentState
add wave -noupdate -radix symbolic /testtraffic/traffic_controller/country_controller/CurrentState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {395 ns} 0}
configure wave -namecolwidth 302
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {247 ns} {503 ns}
