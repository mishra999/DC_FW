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

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/ise/git/DC_backwards/DC_backwards/targetX_modules/source/DigitizingLgcTX.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_3620187407_sub_1366267000076357978_3965413181(char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_16272557775307340295_3965413181(char *, char *, char *, char *, unsigned char );


static void work_a_2092781599_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(63, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4752);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(64, ng0);
    t3 = (t0 + 2632U);
    t4 = *((char **)t3);
    t5 = (0 - 1);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t3 = (t4 + t8);
    t9 = *((unsigned char *)t3);
    t10 = (t0 + 4848);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t9;
    xsi_driver_first_trans_delta(t10, 0U, 1, 0LL);
    xsi_set_current_line(65, ng0);
    t1 = (t0 + 1352U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (t0 + 4848);
    t4 = (t1 + 56U);
    t10 = *((char **)t4);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t2;
    xsi_driver_first_trans_delta(t1, 1U, 1, 0LL);
    goto LAB3;

}

static void work_a_2092781599_3212880686_p_1(char *t0)
{
    char t14[16];
    char t17[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    int t15;
    unsigned int t16;
    char *t18;
    char *t19;
    int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    static char *nl0[] = {&&LAB9, &&LAB10, &&LAB11, &&LAB12};

LAB0:    xsi_set_current_line(72, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4768);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(73, ng0);
    t3 = (t0 + 1192U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t6 = (t5 == (unsigned char)3);
    if (t6 != 0)
        goto LAB5;

LAB7:    xsi_set_current_line(77, ng0);
    t1 = (t0 + 2312U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t1 = (char *)((nl0) + t2);
    goto **((char **)t1);

LAB5:    xsi_set_current_line(74, ng0);
    t3 = (t0 + 4912);
    t7 = (t3 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)0;
    xsi_driver_first_trans_fast(t3);

LAB6:    goto LAB3;

LAB8:    goto LAB6;

LAB9:    xsi_set_current_line(80, ng0);
    t4 = (t0 + 2632U);
    t7 = *((char **)t4);
    t11 = (1 - 1);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t4 = (t7 + t13);
    t8 = (t14 + 0U);
    t9 = (t8 + 0U);
    *((int *)t9) = 1;
    t9 = (t8 + 4U);
    *((int *)t9) = 0;
    t9 = (t8 + 8U);
    *((int *)t9) = -1;
    t15 = (0 - 1);
    t16 = (t15 * -1);
    t16 = (t16 + 1);
    t9 = (t8 + 12U);
    *((unsigned int *)t9) = t16;
    t9 = (t0 + 8753);
    t18 = (t17 + 0U);
    t19 = (t18 + 0U);
    *((int *)t19) = 0;
    t19 = (t18 + 4U);
    *((int *)t19) = 1;
    t19 = (t18 + 8U);
    *((int *)t19) = 1;
    t20 = (1 - 0);
    t16 = (t20 * 1);
    t16 = (t16 + 1);
    t19 = (t18 + 12U);
    *((unsigned int *)t19) = t16;
    t5 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t14, t9, t17);
    if (t5 != 0)
        goto LAB13;

LAB15:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 4976);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(86, ng0);
    t1 = (t0 + 5104);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(87, ng0);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(88, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t3 = t1;
    memset(t3, (unsigned char)2, 12U);
    t4 = (t0 + 5232);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 12U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(89, ng0);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(90, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB14:    goto LAB8;

LAB10:    xsi_set_current_line(94, ng0);
    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t1 = (t0 + 8672U);
    t4 = (t0 + 8755);
    t8 = (t0 + 8640U);
    t2 = ieee_p_3620187407_sub_1366267000076357978_3965413181(IEEE_P_3620187407, t3, t1, t4, t8);
    if (t2 != 0)
        goto LAB16;

LAB18:    xsi_set_current_line(98, ng0);
    t1 = (t0 + 4976);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(99, ng0);
    t1 = (t0 + 5104);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(100, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t3 = t1;
    memset(t3, (unsigned char)2, 12U);
    t4 = (t0 + 5232);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 12U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(101, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);

LAB17:    goto LAB8;

LAB11:    xsi_set_current_line(105, ng0);
    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t1 = (t0 + 8672U);
    t4 = (t0 + 8762);
    t8 = (t0 + 8624U);
    t2 = ieee_p_3620187407_sub_1366267000076357978_3965413181(IEEE_P_3620187407, t3, t1, t4, t8);
    if (t2 != 0)
        goto LAB21;

LAB23:    xsi_set_current_line(109, ng0);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(110, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t3 = t1;
    memset(t3, (unsigned char)2, 12U);
    t4 = (t0 + 5232);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 12U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(111, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);

LAB22:    goto LAB8;

LAB12:    xsi_set_current_line(115, ng0);
    t1 = (t0 + 2472U);
    t3 = *((char **)t1);
    t11 = (11 - 11);
    t12 = (t11 * 1U);
    t13 = (0 + t12);
    t1 = (t3 + t13);
    t4 = (t14 + 0U);
    t7 = (t4 + 0U);
    *((int *)t7) = 11;
    t7 = (t4 + 4U);
    *((int *)t7) = 6;
    t7 = (t4 + 8U);
    *((int *)t7) = -1;
    t15 = (6 - 11);
    t16 = (t15 * -1);
    t16 = (t16 + 1);
    t7 = (t4 + 12U);
    *((unsigned int *)t7) = t16;
    t7 = (t0 + 1672U);
    t8 = *((char **)t7);
    t7 = (t0 + 8656U);
    t2 = ieee_p_3620187407_sub_1366267000076357978_3965413181(IEEE_P_3620187407, t1, t14, t8, t7);
    if (t2 != 0)
        goto LAB26;

LAB28:    xsi_set_current_line(119, ng0);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(120, ng0);
    t1 = (t0 + 5104);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(121, ng0);
    t1 = (t0 + 5168);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(122, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t3 = t1;
    memset(t3, (unsigned char)2, 12U);
    t4 = (t0 + 5232);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 12U);
    xsi_driver_first_trans_fast(t4);
    xsi_set_current_line(123, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB27:    goto LAB8;

LAB13:    xsi_set_current_line(81, ng0);
    t19 = (t0 + 4976);
    t21 = (t19 + 56U);
    t22 = *((char **)t21);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t19);
    xsi_set_current_line(82, ng0);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(83, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)1;
    xsi_driver_first_trans_fast(t1);
    goto LAB14;

LAB16:    xsi_set_current_line(95, ng0);
    t9 = (t0 + 2472U);
    t10 = *((char **)t9);
    t9 = (t0 + 8672U);
    t18 = ieee_p_3620187407_sub_16272557775307340295_3965413181(IEEE_P_3620187407, t14, t10, t9, (unsigned char)3);
    t19 = (t14 + 12U);
    t11 = *((unsigned int *)t19);
    t12 = (1U * t11);
    t5 = (12U != t12);
    if (t5 == 1)
        goto LAB19;

LAB20:    t21 = (t0 + 5232);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t18, 12U);
    xsi_driver_first_trans_fast(t21);
    xsi_set_current_line(96, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)1;
    xsi_driver_first_trans_fast(t1);
    goto LAB17;

LAB19:    xsi_size_not_matching(12U, t12, 0);
    goto LAB20;

LAB21:    xsi_set_current_line(106, ng0);
    t9 = (t0 + 2472U);
    t10 = *((char **)t9);
    t9 = (t0 + 8672U);
    t18 = ieee_p_3620187407_sub_16272557775307340295_3965413181(IEEE_P_3620187407, t14, t10, t9, (unsigned char)3);
    t19 = (t14 + 12U);
    t11 = *((unsigned int *)t19);
    t12 = (1U * t11);
    t5 = (12U != t12);
    if (t5 == 1)
        goto LAB24;

LAB25:    t21 = (t0 + 5232);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t18, 12U);
    xsi_driver_first_trans_fast(t21);
    xsi_set_current_line(107, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB22;

LAB24:    xsi_size_not_matching(12U, t12, 0);
    goto LAB25;

LAB26:    xsi_set_current_line(116, ng0);
    t9 = (t0 + 2472U);
    t10 = *((char **)t9);
    t9 = (t0 + 8672U);
    t18 = ieee_p_3620187407_sub_16272557775307340295_3965413181(IEEE_P_3620187407, t17, t10, t9, (unsigned char)3);
    t19 = (t17 + 12U);
    t16 = *((unsigned int *)t19);
    t26 = (1U * t16);
    t5 = (12U != t26);
    if (t5 == 1)
        goto LAB29;

LAB30:    t21 = (t0 + 5232);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t18, 12U);
    xsi_driver_first_trans_fast(t21);
    xsi_set_current_line(117, ng0);
    t1 = (t0 + 4912);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t7 = (t4 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB27;

LAB29:    xsi_size_not_matching(12U, t26, 0);
    goto LAB30;

}


extern void work_a_2092781599_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2092781599_3212880686_p_0,(void *)work_a_2092781599_3212880686_p_1};
	xsi_register_didat("work_a_2092781599_3212880686", "isim/TargetX_data_tb_isim_beh.exe.sim/work/a_2092781599_3212880686.didat");
	xsi_register_executes(pe);
}
