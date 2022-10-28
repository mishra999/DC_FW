gui_open_window Wave
gui_sg_create DCM_CLK_For_QBL_group
gui_list_add_group -id Wave.1 {DCM_CLK_For_QBL_group}
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.test_phase}
gui_set_radix -radix {ascii} -signals {DCM_CLK_For_QBL_tb.test_phase}
gui_sg_addsignal -group DCM_CLK_For_QBL_group {{Input_clocks}} -divider
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.CLK_IN1}
gui_sg_addsignal -group DCM_CLK_For_QBL_group {{Output_clocks}} -divider
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.dut.clk}
gui_list_expand -id Wave.1 DCM_CLK_For_QBL_tb.dut.clk
gui_sg_addsignal -group DCM_CLK_For_QBL_group {{Status_control}} -divider
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.RESET}
gui_sg_addsignal -group DCM_CLK_For_QBL_group {{Counters}} -divider
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.COUNT}
gui_sg_addsignal -group DCM_CLK_For_QBL_group {DCM_CLK_For_QBL_tb.dut.counter}
gui_list_expand -id Wave.1 DCM_CLK_For_QBL_tb.dut.counter
gui_zoom -window Wave.1 -full
