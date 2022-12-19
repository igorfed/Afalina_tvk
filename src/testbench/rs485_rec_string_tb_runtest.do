SetActiveLib -work
comp -include "$DSN\src\rs485_rec_string.vhd" 
comp -include "$DSN\src\TestBench\rs485_rec_string_TB.vhd" 
asim TESTBENCH_FOR_rs485_rec_string 
wave 
wave -noreg REC_FT
wave -noreg RESET
wave -noreg REC_DATE
wave -noreg REC_ADDR
wave -noreg REC_ADDR_EN
wave -noreg REC_DATE_EN
wave -noreg RXDATA
wave -noreg NBYTE
wave -noreg RXD_ERROR
wave -noreg RXD_OK
wave -noreg SUMM_CTRL
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\rs485_rec_string_TB_tim_cfg.vhd" 
# asim TIMING_FOR_rs485_rec_string 
