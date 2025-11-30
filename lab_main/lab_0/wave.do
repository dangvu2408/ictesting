onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /alu_32bit_tb/uut/src1
add wave -noupdate -expand /alu_32bit_tb/uut/src2
add wave -noupdate -expand /alu_32bit_tb/uut/alu_op
add wave -noupdate -expand /alu_32bit_tb/uut/res
add wave -noupdate /alu_32bit_tb/uut/overflow
add wave -noupdate -expand /alu_32bit_tb/uut/add_res
add wave -noupdate -expand /alu_32bit_tb/uut/sub_res
add wave -noupdate -expand /alu_32bit_tb/uut/mul_res
add wave -noupdate -expand /alu_32bit_tb/uut/and_res
add wave -noupdate -expand /alu_32bit_tb/uut/or_res
add wave -noupdate -expand /alu_32bit_tb/uut/xor_res
add wave -noupdate -expand /alu_32bit_tb/uut/sll_res
add wave -noupdate -expand /alu_32bit_tb/uut/srl_res
add wave -noupdate /alu_32bit_tb/uut/add_ovf
add wave -noupdate /alu_32bit_tb/uut/sub_ovf
add wave -noupdate /alu_32bit_tb/uut/mul_ovf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {157500 ps}
