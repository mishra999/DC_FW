/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_1242562249;
char *STD_STANDARD;
char *WORK_P_2768778539;
char *IEEE_P_2592010699;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *WORK_P_3769813568;
char *WORK_P_1711965120;
char *IEEE_P_0017514958;
char *SYNOPSYS_P_3308480207;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    synopsys_p_3308480207_init();
    ieee_p_0017514958_init();
    ieee_p_1242562249_init();
    work_p_1711965120_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_p_3769813568_init();
    work_p_2768778539_init();
    work_a_2136280892_3212880686_init();
    work_a_2971716336_3212880686_init();


    xsi_register_tops("work_a_2971716336_3212880686");

    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    WORK_P_2768778539 = xsi_get_engine_memory("work_p_2768778539");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    WORK_P_3769813568 = xsi_get_engine_memory("work_p_3769813568");
    WORK_P_1711965120 = xsi_get_engine_memory("work_p_1711965120");
    IEEE_P_0017514958 = xsi_get_engine_memory("ieee_p_0017514958");
    SYNOPSYS_P_3308480207 = xsi_get_engine_memory("synopsys_p_3308480207");

    return xsi_run_simulation(argc, argv);

}
