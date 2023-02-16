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
static const char *ng0 = "/home/ise/git/DC_backwards/DC_backwards/target_x_dac_control/src/TargetX_DAC_TB.vhd";
extern char *IEEE_P_2592010699;



static void work_a_2971716336_3212880686_p_0(char *t0)
{
    char t20[16];
    char t22[16];
    char t27[16];
    char *t1;
    char *t2;
    unsigned int t3;
    unsigned int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    unsigned int t12;
    unsigned int t13;
    int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    char *t19;
    char *t21;
    char *t23;
    char *t24;
    int t25;
    unsigned int t26;
    char *t28;
    int t29;
    unsigned char t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;

LAB0:    xsi_set_current_line(66, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (15 - 6);
    t4 = (t3 * 1U);
    t5 = (1 - 4);
    t6 = (t5 * -1);
    t7 = (16U * t6);
    t8 = (0 + t7);
    t9 = (t8 + t4);
    t1 = (t2 + t9);
    t10 = (t0 + 2472U);
    t11 = *((char **)t10);
    t12 = (15 - 11);
    t13 = (t12 * 1U);
    t14 = (2 - 4);
    t15 = (t14 * -1);
    t16 = (16U * t15);
    t17 = (0 + t16);
    t18 = (t17 + t13);
    t10 = (t11 + t18);
    t21 = ((IEEE_P_2592010699) + 4000);
    t23 = (t22 + 0U);
    t24 = (t23 + 0U);
    *((int *)t24) = 6;
    t24 = (t23 + 4U);
    *((int *)t24) = 0;
    t24 = (t23 + 8U);
    *((int *)t24) = -1;
    t25 = (0 - 6);
    t26 = (t25 * -1);
    t26 = (t26 + 1);
    t24 = (t23 + 12U);
    *((unsigned int *)t24) = t26;
    t24 = (t27 + 0U);
    t28 = (t24 + 0U);
    *((int *)t28) = 11;
    t28 = (t24 + 4U);
    *((int *)t28) = 0;
    t28 = (t24 + 8U);
    *((int *)t28) = -1;
    t29 = (0 - 11);
    t26 = (t29 * -1);
    t26 = (t26 + 1);
    t28 = (t24 + 12U);
    *((unsigned int *)t28) = t26;
    t19 = xsi_base_array_concat(t19, t20, t21, (char)97, t1, t22, (char)97, t10, t27, (char)101);
    t26 = (7U + 12U);
    t30 = (19U != t26);
    if (t30 == 1)
        goto LAB5;

LAB6:    t28 = (t0 + 5808);
    t31 = (t28 + 56U);
    t32 = *((char **)t31);
    t33 = (t32 + 56U);
    t34 = *((char **)t33);
    memcpy(t34, t19, 19U);
    xsi_driver_first_trans_fast(t28);

LAB2:    t35 = (t0 + 5696);
    *((int *)t35) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(19U, t26, 0);
    goto LAB6;

}

static void work_a_2971716336_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    xsi_set_current_line(67, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (3 - 4);
    t4 = (t3 * -1);
    t5 = (16U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = (t0 + 5872);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 16U);
    xsi_driver_first_trans_fast(t7);

LAB2:    t12 = (t0 + 5712);
    *((int *)t12) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2971716336_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    xsi_set_current_line(68, ng0);

LAB3:    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = (4 - 4);
    t4 = (t3 * -1);
    t5 = (16U * t4);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = (t0 + 5936);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 16U);
    xsi_driver_first_trans_fast(t7);

LAB2:    t12 = (t0 + 5728);
    *((int *)t12) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2971716336_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int64 t7;
    int64 t8;

LAB0:    t1 = (t0 + 5128U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 6000);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(88, ng0);
    t2 = (t0 + 3048U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 4936);
    xsi_process_wait(t2, t8);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(89, ng0);
    t2 = (t0 + 6000);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(90, ng0);
    t2 = (t0 + 3048U);
    t3 = *((char **)t2);
    t7 = *((int64 *)t3);
    t8 = (t7 / 2);
    t2 = (t0 + 4936);
    xsi_process_wait(t2, t8);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    goto LAB2;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

}

static void work_a_2971716336_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    int64 t3;
    char *t4;
    int64 t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    t1 = (t0 + 5376U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(98, ng0);
    t3 = (100 * 1000LL);
    t2 = (t0 + 5184);
    xsi_process_wait(t2, t3);

LAB6:    *((char **)t1) = &&LAB7;

LAB1:    return;
LAB4:    xsi_set_current_line(100, ng0);
    t2 = (t0 + 3048U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 5184);
    xsi_process_wait(t2, t5);

LAB10:    *((char **)t1) = &&LAB11;
    goto LAB1;

LAB5:    goto LAB4;

LAB7:    goto LAB5;

LAB8:    xsi_set_current_line(101, ng0);
    t2 = (t0 + 10672);
    t6 = (16U != 16U);
    if (t6 == 1)
        goto LAB12;

LAB13:    t7 = (t0 + 6064);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t2, 16U);
    xsi_driver_first_trans_delta(t7, 16U, 16U, 0LL);
    xsi_set_current_line(102, ng0);
    t2 = (t0 + 10688);
    t6 = (16U != 16U);
    if (t6 == 1)
        goto LAB14;

LAB15:    t7 = (t0 + 6064);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t2, 16U);
    xsi_driver_first_trans_delta(t7, 0U, 16U, 0LL);
    xsi_set_current_line(103, ng0);
    t2 = (t0 + 3048U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 1);
    t2 = (t0 + 5184);
    xsi_process_wait(t2, t5);

LAB18:    *((char **)t1) = &&LAB19;
    goto LAB1;

LAB9:    goto LAB8;

LAB11:    goto LAB9;

LAB12:    xsi_size_not_matching(16U, 16U, 0);
    goto LAB13;

LAB14:    xsi_size_not_matching(16U, 16U, 0);
    goto LAB15;

LAB16:    xsi_set_current_line(104, ng0);
    t2 = (t0 + 10704);
    t6 = (16U != 16U);
    if (t6 == 1)
        goto LAB20;

LAB21:    t7 = (t0 + 6064);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t2, 16U);
    xsi_driver_first_trans_delta(t7, 48U, 16U, 0LL);
    xsi_set_current_line(105, ng0);
    t2 = (t0 + 10720);
    t6 = (16U != 16U);
    if (t6 == 1)
        goto LAB22;

LAB23:    t7 = (t0 + 6064);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t2, 16U);
    xsi_driver_first_trans_delta(t7, 32U, 16U, 0LL);
    xsi_set_current_line(106, ng0);
    t2 = (t0 + 6128);
    t4 = (t2 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(107, ng0);
    t2 = (t0 + 3048U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t2 = (t0 + 5184);
    xsi_process_wait(t2, t3);

LAB26:    *((char **)t1) = &&LAB27;
    goto LAB1;

LAB17:    goto LAB16;

LAB19:    goto LAB17;

LAB20:    xsi_size_not_matching(16U, 16U, 0);
    goto LAB21;

LAB22:    xsi_size_not_matching(16U, 16U, 0);
    goto LAB23;

LAB24:    xsi_set_current_line(108, ng0);
    t2 = (t0 + 6128);
    t4 = (t2 + 56U);
    t7 = *((char **)t4);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(110, ng0);
    t2 = (t0 + 3048U);
    t4 = *((char **)t2);
    t3 = *((int64 *)t4);
    t5 = (t3 * 100);
    t2 = (t0 + 5184);
    xsi_process_wait(t2, t5);

LAB30:    *((char **)t1) = &&LAB31;
    goto LAB1;

LAB25:    goto LAB24;

LAB27:    goto LAB25;

LAB28:    xsi_set_current_line(119, ng0);

LAB34:    *((char **)t1) = &&LAB35;
    goto LAB1;

LAB29:    goto LAB28;

LAB31:    goto LAB29;

LAB32:    goto LAB2;

LAB33:    goto LAB32;

LAB35:    goto LAB33;

}


extern void work_a_2971716336_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2971716336_3212880686_p_0,(void *)work_a_2971716336_3212880686_p_1,(void *)work_a_2971716336_3212880686_p_2,(void *)work_a_2971716336_3212880686_p_3,(void *)work_a_2971716336_3212880686_p_4};
	xsi_register_didat("work_a_2971716336_3212880686", "isim/TX_DAC_control_w_regInterface_tb_isim_beh.exe.sim/work/a_2971716336_3212880686.didat");
	xsi_register_executes(pe);
}
