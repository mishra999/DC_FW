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

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_3499444699;
char *IEEE_P_3620187407;
char *IEEE_P_1242562249;
char *WORK_P_0761366881;
char *WORK_P_3153913483;
char *IEEE_P_3972351953;
char *WORK_P_3977757524;
char *WORK_P_1972988568;
char *WORK_P_0487524481;
char *UNISIM_P_0947159679;
char *IEEE_P_0017514958;
char *SYNOPSYS_P_3308480207;
char *WORK_P_4250642694;
char *WORK_P_2768778539;
char *WORK_P_3769813568;
char *WORK_P_1711965120;
char *STD_TEXTIO;
char *IEEE_P_1367372525;
char *UNISIM_P_3222816464;
char *IEEE_P_2717149903;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_p_1711965120_init();
    work_p_3769813568_init();
    work_p_2768778539_init();
    work_p_4250642694_init();
    work_p_0487524481_init();
    ieee_p_3972351953_init();
    work_p_3977757524_init();
    work_p_0761366881_init();
    work_p_3153913483_init();
    work_p_1972988568_init();
    unisim_p_0947159679_init();
    synopsys_p_3308480207_init();
    ieee_p_0017514958_init();
    unisim_a_2340387572_1864968857_init();
    work_a_2606312688_1181938964_init();
    std_textio_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    unisim_p_3222816464_init();
    xilinxcorelib_a_2929639361_3212880686_init();
    xilinxcorelib_a_3606286955_3212880686_init();
    xilinxcorelib_a_2523763003_3212880686_init();
    work_a_1244718436_2052900076_init();
    unisim_a_0347976373_0621957688_init();
    work_a_1645520677_3212880686_init();
    unisim_a_3014403764_1187145474_init();
    work_a_3035903171_3212880686_init();
    work_a_2741925868_1516540902_init();
    work_a_4189508887_1516540902_init();
    work_a_1884529077_1516540902_init();
    xilinxcorelib_a_2719822303_3212880686_init();
    xilinxcorelib_a_2570771257_3212880686_init();
    xilinxcorelib_a_3898511197_3212880686_init();
    xilinxcorelib_a_1059662729_3212880686_init();
    work_a_2551899526_2492096576_init();
    xilinxcorelib_a_0684785865_3212880686_init();
    xilinxcorelib_a_2353723240_3212880686_init();
    xilinxcorelib_a_2616109775_3212880686_init();
    xilinxcorelib_a_4001072199_3212880686_init();
    work_a_3652411724_3740038030_init();
    work_a_0934933731_3212880686_init();
    work_a_0445720317_3797831714_init();
    work_a_2775425109_3797831714_init();
    xilinxcorelib_a_3528006616_3212880686_init();
    xilinxcorelib_a_1120212549_3212880686_init();
    xilinxcorelib_a_2017763730_3212880686_init();
    work_a_3799944196_2869669832_init();
    work_a_0611294277_1516540902_init();
    work_a_2092781599_3212880686_init();
    work_a_0310176134_3212880686_init();
    work_a_1365443005_3212880686_init();
    work_a_0626752313_3212880686_init();
    work_a_3649108284_3212880686_init();
    xilinxcorelib_a_3812322454_3212880686_init();
    xilinxcorelib_a_2058658382_3212880686_init();
    xilinxcorelib_a_0779408934_3212880686_init();
    work_a_3830851868_1832285448_init();
    work_a_3939661329_1516540902_init();


    xsi_register_tops("work_a_3939661329_1516540902");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    WORK_P_0761366881 = xsi_get_engine_memory("work_p_0761366881");
    WORK_P_3153913483 = xsi_get_engine_memory("work_p_3153913483");
    IEEE_P_3972351953 = xsi_get_engine_memory("ieee_p_3972351953");
    WORK_P_3977757524 = xsi_get_engine_memory("work_p_3977757524");
    WORK_P_1972988568 = xsi_get_engine_memory("work_p_1972988568");
    WORK_P_0487524481 = xsi_get_engine_memory("work_p_0487524481");
    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    IEEE_P_0017514958 = xsi_get_engine_memory("ieee_p_0017514958");
    SYNOPSYS_P_3308480207 = xsi_get_engine_memory("synopsys_p_3308480207");
    WORK_P_4250642694 = xsi_get_engine_memory("work_p_4250642694");
    WORK_P_2768778539 = xsi_get_engine_memory("work_p_2768778539");
    WORK_P_3769813568 = xsi_get_engine_memory("work_p_3769813568");
    WORK_P_1711965120 = xsi_get_engine_memory("work_p_1711965120");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    UNISIM_P_3222816464 = xsi_get_engine_memory("unisim_p_3222816464");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");

    return xsi_run_simulation(argc, argv);

}
