onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ee457_scpu_tb/clk
add wave -noupdate /ee457_scpu_tb/rst
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/imem_wdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/imem_rdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/imem_addr
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/imemread
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/imemwrite
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_ra
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_rb
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_wa
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_radata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_rbdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/reg_wdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/regwrite
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/dmem_wdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/dmem_rdata
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/dmem_addr
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/dmemread
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/dmemwrite
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/uut/pc
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/uut/alu_func
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/uut/alu_res
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/uut/jump_target_pc
add wave -noupdate -radix hexadecimal /ee457_scpu_tb/uut/branch_target_pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38668 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {196876 ps}
