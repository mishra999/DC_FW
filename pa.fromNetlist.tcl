
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name DC_backwards -dir "/home/ise/git/DC_backwards/DC_backwards/planAhead_run_1" -part xc6slx4tqg144-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/ise/git/DC_backwards/DC_backwards/DC_FPGA_TOP_cs.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ise/git/DC_backwards/DC_backwards} {cores/coregen} {cores/ipcore_dir} }
add_files [list {cores/coregen/bram8x3000.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/CMD_FIFO_w1r8.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/CMD_FIFO_w8r32.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/fifo16x64.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/fifo18x16.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/fifo32x512RxAxi.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/fifo8x64.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/fifoDist8x16.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/QBLtxFIFO.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/serializationFifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/srout_bram_blkmem.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/udp64kfifo.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/coregen/waveform_fifo_wr32_rd32.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {cores/ipcore_dir/axi_fifo_32w_32d.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "/home/ise/git/DC_backwards/DC_backwards/constraint/HMB_DC.ucf" [current_fileset -constrset]
add_files [list {/home/ise/git/DC_backwards/DC_backwards/constraint/HMB_DC.ucf}] -fileset [get_property constrset [current_run]]
link_design
