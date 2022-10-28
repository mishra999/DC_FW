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
static const char *ng0 = "/home/ise/git/SiRead_FW1/sources/DC_Comm_back_test1.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_17802405650254020620_1035706684(char *, char *, char *);
unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_0848641654_2372691052_p_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 6344U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(138, ng0);
    t2 = (t0 + 7256);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(139, ng0);
    t2 = (t0 + 5128U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 6152);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(140, ng0);
    t2 = (t0 + 7256);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(141, ng0);
    t2 = (t0 + 5128U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 6152);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_0848641654_2372691052_p_1(char *t0)
{
    char t8[16];
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    unsigned char t17;
    unsigned char t18;
    unsigned char t19;
    int t20;
    unsigned int t21;
    unsigned int t22;

LAB0:    xsi_set_current_line(165, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 7160);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(166, ng0);
    t3 = (t0 + 7320);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_delta(t3, 0U, 1, 0LL);
    xsi_set_current_line(167, ng0);
    t1 = (t0 + 1992U);
    t3 = *((char **)t1);
    t1 = (t0 + 12472U);
    t4 = (t0 + 13312);
    t6 = (t8 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 0;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t9 = (0 - 0);
    t10 = (t9 * 1);
    t10 = (t10 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t10;
    t2 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t3, t1, t4, t8);
    if (t2 != 0)
        goto LAB5;

LAB7:    t1 = (t0 + 4072U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t17 = (t2 == (unsigned char)3);
    if (t17 != 0)
        goto LAB8;

LAB9:
LAB6:    goto LAB3;

LAB5:    xsi_set_current_line(168, ng0);
    t7 = xsi_get_transient_memory(32U);
    memset(t7, 0, 32U);
    t11 = t7;
    memset(t11, (unsigned char)2, 32U);
    t12 = (t0 + 7384);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t7, 32U);
    xsi_driver_first_trans_fast(t12);
    goto LAB6;

LAB8:    xsi_set_current_line(171, ng0);
    t1 = (t0 + 4232U);
    t4 = *((char **)t1);
    t18 = *((unsigned char *)t4);
    t19 = (t18 == (unsigned char)2);
    if (t19 != 0)
        goto LAB10;

LAB12:    t1 = (t0 + 4232U);
    t3 = *((char **)t1);
    t2 = *((unsigned char *)t3);
    t17 = (t2 == (unsigned char)3);
    if (t17 != 0)
        goto LAB13;

LAB14:
LAB11:    goto LAB6;

LAB10:    xsi_set_current_line(172, ng0);
    t1 = (t0 + 4712U);
    t5 = *((char **)t1);
    t1 = (t0 + 3752U);
    t6 = *((char **)t1);
    t1 = (t0 + 12632U);
    t9 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t6, t1);
    t20 = (t9 - 19);
    t10 = (t20 * -1);
    xsi_vhdl_check_range_of_index(19, 0, -1, t9);
    t21 = (16U * t10);
    t22 = (0 + t21);
    t7 = (t5 + t22);
    t11 = (t0 + 7384);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t7, 16U);
    xsi_driver_first_trans_delta(t11, 16U, 16U, 0LL);
    xsi_set_current_line(173, ng0);
    t1 = (t0 + 7320);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    goto LAB11;

LAB13:    xsi_set_current_line(175, ng0);
    t1 = (t0 + 3912U);
    t4 = *((char **)t1);
    t1 = (t0 + 3752U);
    t5 = *((char **)t1);
    t1 = (t0 + 12632U);
    t9 = ieee_p_1242562249_sub_17802405650254020620_1035706684(IEEE_P_1242562249, t5, t1);
    t20 = (t9 - 19);
    t10 = (t20 * -1);
    t21 = (16U * t10);
    t22 = (0U + t21);
    t6 = (t0 + 7448);
    t7 = (t6 + 56U);
    t11 = *((char **)t7);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t4, 16U);
    xsi_driver_first_trans_delta(t6, t22, 16U, 0LL);
    xsi_set_current_line(176, ng0);
    t1 = (t0 + 3752U);
    t3 = *((char **)t1);
    t1 = (t0 + 7384);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 16U);
    xsi_driver_first_trans_delta(t1, 16U, 16U, 0LL);
    xsi_set_current_line(177, ng0);
    t1 = (t0 + 7320);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_delta(t1, 0U, 1, 0LL);
    goto LAB11;

}

static void work_a_0848641654_2372691052_p_2(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned char t16;
    unsigned char t17;
    int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned char t22;
    unsigned char t23;

LAB0:    t1 = (t0 + 6840U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(201, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(202, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(203, ng0);
    t2 = (t0 + 13313);
    t6 = (t0 + 7512);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(204, ng0);
    t2 = (t0 + 13314);
    t6 = (t0 + 7576);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(211, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB14:    *((char **)t1) = &&LAB15;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_set_current_line(212, ng0);
    t2 = (t0 + 13315);
    t6 = (t0 + 7512);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(213, ng0);
    t2 = (t0 + 13316);
    t6 = (t0 + 7576);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(222, ng0);

LAB18:    t2 = (t0 + 7176);
    *((int *)t2) = 1;
    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB13:    goto LAB12;

LAB15:    goto LAB13;

LAB16:    t9 = (t0 + 7176);
    *((int *)t9) = 0;
    xsi_set_current_line(223, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 2);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB25:    *((char **)t1) = &&LAB26;
    goto LAB1;

LAB17:    t4 = (t0 + 3432U);
    t6 = *((char **)t4);
    t12 = (0 - 0);
    t13 = (t12 * -1);
    t14 = (1U * t13);
    t15 = (0 + t14);
    t4 = (t6 + t15);
    t16 = *((unsigned char *)t4);
    t17 = (t16 == (unsigned char)3);
    if (t17 == 1)
        goto LAB20;

LAB21:    t11 = (unsigned char)0;

LAB22:    if (t11 == 1)
        goto LAB16;
    else
        goto LAB18;

LAB19:    goto LAB17;

LAB20:    t7 = (t0 + 3272U);
    t8 = *((char **)t7);
    t18 = (0 - 0);
    t19 = (t18 * -1);
    t20 = (1U * t19);
    t21 = (0 + t20);
    t7 = (t8 + t21);
    t22 = *((unsigned char *)t7);
    t23 = (t22 == (unsigned char)3);
    t11 = t23;
    goto LAB22;

LAB23:    xsi_set_current_line(228, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 100);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB29:    *((char **)t1) = &&LAB30;
    goto LAB1;

LAB24:    goto LAB23;

LAB26:    goto LAB24;

LAB27:    xsi_set_current_line(229, ng0);
    t2 = (t0 + 13317);
    t6 = (t0 + 7512);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(230, ng0);
    t2 = (t0 + 13318);
    t6 = (t0 + 7576);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(231, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB33:    *((char **)t1) = &&LAB34;
    goto LAB1;

LAB28:    goto LAB27;

LAB30:    goto LAB28;

LAB31:    xsi_set_current_line(232, ng0);
    t2 = (t0 + 13319);
    t6 = (t0 + 7640);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(233, ng0);
    t2 = (t0 + 13320);
    t6 = (t0 + 7704);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(237, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 10);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB37:    *((char **)t1) = &&LAB38;
    goto LAB1;

LAB32:    goto LAB31;

LAB34:    goto LAB32;

LAB35:    xsi_set_current_line(238, ng0);
    t2 = (t0 + 13321);
    t6 = (t0 + 7512);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(239, ng0);
    t2 = (t0 + 13322);
    t6 = (t0 + 7576);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(240, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB41:    *((char **)t1) = &&LAB42;
    goto LAB1;

LAB36:    goto LAB35;

LAB38:    goto LAB36;

LAB39:    xsi_set_current_line(241, ng0);
    t2 = (t0 + 13323);
    t6 = (t0 + 7640);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(243, ng0);
    t2 = (t0 + 13324);
    t6 = (t0 + 7704);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 1U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(248, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 2);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB45:    *((char **)t1) = &&LAB46;
    goto LAB1;

LAB40:    goto LAB39;

LAB42:    goto LAB40;

LAB43:    xsi_set_current_line(249, ng0);
    t2 = (t0 + 5248U);
    t4 = *((char **)t2);
    t2 = (t0 + 7768);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t4, 32U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(250, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(251, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB49:    *((char **)t1) = &&LAB50;
    goto LAB1;

LAB44:    goto LAB43;

LAB46:    goto LAB44;

LAB47:    xsi_set_current_line(252, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(255, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB53:    *((char **)t1) = &&LAB54;
    goto LAB1;

LAB48:    goto LAB47;

LAB50:    goto LAB48;

LAB51:    xsi_set_current_line(256, ng0);
    t2 = (t0 + 13325);
    t6 = (t0 + 7768);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 32U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(257, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(258, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB57:    *((char **)t1) = &&LAB58;
    goto LAB1;

LAB52:    goto LAB51;

LAB54:    goto LAB52;

LAB55:    xsi_set_current_line(259, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(260, ng0);
    t2 = (t0 + 7896);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(262, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB61:    *((char **)t1) = &&LAB62;
    goto LAB1;

LAB56:    goto LAB55;

LAB58:    goto LAB56;

LAB59:    xsi_set_current_line(263, ng0);
    t2 = (t0 + 5368U);
    t4 = *((char **)t2);
    t2 = (t0 + 7768);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t4, 32U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(264, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(265, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB65:    *((char **)t1) = &&LAB66;
    goto LAB1;

LAB60:    goto LAB59;

LAB62:    goto LAB60;

LAB63:    xsi_set_current_line(266, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(269, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB69:    *((char **)t1) = &&LAB70;
    goto LAB1;

LAB64:    goto LAB63;

LAB66:    goto LAB64;

LAB67:    xsi_set_current_line(270, ng0);
    t2 = (t0 + 13357);
    t6 = (t0 + 7768);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 32U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(271, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(272, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB73:    *((char **)t1) = &&LAB74;
    goto LAB1;

LAB68:    goto LAB67;

LAB70:    goto LAB68;

LAB71:    xsi_set_current_line(273, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(274, ng0);
    t2 = (t0 + 7896);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(276, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB77:    *((char **)t1) = &&LAB78;
    goto LAB1;

LAB72:    goto LAB71;

LAB74:    goto LAB72;

LAB75:    xsi_set_current_line(277, ng0);
    t2 = (t0 + 5368U);
    t4 = *((char **)t2);
    t2 = (t0 + 7768);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t4, 32U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(278, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(279, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB81:    *((char **)t1) = &&LAB82;
    goto LAB1;

LAB76:    goto LAB75;

LAB78:    goto LAB76;

LAB79:    xsi_set_current_line(280, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(283, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t5);

LAB85:    *((char **)t1) = &&LAB86;
    goto LAB1;

LAB80:    goto LAB79;

LAB82:    goto LAB80;

LAB83:    xsi_set_current_line(284, ng0);
    t2 = (t0 + 13389);
    t6 = (t0 + 7768);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t2, 32U);
    xsi_driver_first_trans_fast(t6);
    xsi_set_current_line(285, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(286, ng0);
    t2 = (t0 + 5128U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 6648);
    xsi_process_wait(t2, t3);

LAB89:    *((char **)t1) = &&LAB90;
    goto LAB1;

LAB84:    goto LAB83;

LAB86:    goto LAB84;

LAB87:    xsi_set_current_line(287, ng0);
    t2 = (t0 + 7832);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(288, ng0);
    t2 = (t0 + 7896);
    t4 = (t2 + 56U);
    t6 = *((char **)t4);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)3;
    xsi_driver_first_trans_delta(t2, 0U, 1, 0LL);
    xsi_set_current_line(289, ng0);

LAB93:    *((char **)t1) = &&LAB94;
    goto LAB1;

LAB88:    goto LAB87;

LAB90:    goto LAB88;

LAB91:    goto LAB2;

LAB92:    goto LAB91;

LAB94:    goto LAB92;

}


extern void work_a_0848641654_2372691052_init()
{
	static char *pe[] = {(void *)work_a_0848641654_2372691052_p_0,(void *)work_a_0848641654_2372691052_p_1,(void *)work_a_0848641654_2372691052_p_2};
	xsi_register_didat("work_a_0848641654_2372691052", "isim/DC_Comm_QBLinkTB_isim_beh.exe.sim/work/a_0848641654_2372691052.didat");
	xsi_register_executes(pe);
}
