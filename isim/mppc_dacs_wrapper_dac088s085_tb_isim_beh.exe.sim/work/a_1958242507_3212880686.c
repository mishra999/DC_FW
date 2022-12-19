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
static const char *ng0 = "/home/ise/git/DC_backwards/DC_backwards/mppc_bias_dac088s085.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );
char *ieee_p_3620187407_sub_2255506239096166994_3965413181(char *, char *, char *, char *, int );


static void work_a_1958242507_3212880686_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(77, ng0);
    t2 = (t0 + 992U);
    t3 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t2, 0U, 0U);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 6280);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(78, ng0);
    t4 = (t0 + 1672U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t4 = (t0 + 6392);
    t10 = (t4 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t9;
    xsi_driver_first_trans_fast(t4);
    goto LAB3;

LAB5:    t4 = (t0 + 1192U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

}

static void work_a_1958242507_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(82, ng0);

LAB3:    t1 = (t0 + 4072U);
    t2 = *((char **)t1);
    t1 = (t0 + 6456);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 6296);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_1958242507_3212880686_p_2(char *t0)
{
    char t15[16];
    char t25[16];
    char t26[16];
    char t31[16];
    char t37[16];
    char t39[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t27;
    int t28;
    unsigned int t29;
    char *t30;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t38;
    char *t40;
    char *t41;
    int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    char *t46;
    char *t47;
    char *t48;
    char *t49;
    int t50;
    static char *nl0[] = {&&LAB9, &&LAB10, &&LAB11, &&LAB12, &&LAB13, &&LAB14, &&LAB16, &&LAB15};

LAB0:    xsi_set_current_line(87, ng0);
    t2 = (t0 + 992U);
    t3 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t2, 0U, 0U);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 6312);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(90, ng0);
    t4 = (t0 + 3912U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t4 = (char *)((nl0) + t9);
    goto **((char **)t4);

LAB5:    t4 = (t0 + 1192U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    goto LAB3;

LAB9:    xsi_set_current_line(93, ng0);
    t10 = (t0 + 6520);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t10);
    xsi_set_current_line(94, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(95, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(96, ng0);
    t2 = (t0 + 1352U);
    t4 = *((char **)t2);
    t2 = (t0 + 6712);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t4, 4U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(97, ng0);
    t2 = (t0 + 1512U);
    t4 = *((char **)t2);
    t2 = (t0 + 6776);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t4, 8U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(98, ng0);
    t2 = (t0 + 1672U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t3 = (t1 == (unsigned char)3);
    if (t3 != 0)
        goto LAB17;

LAB19:    xsi_set_current_line(102, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(103, ng0);
    t2 = (t0 + 6904);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);

LAB18:    goto LAB8;

LAB10:    xsi_set_current_line(107, ng0);
    t2 = (t0 + 4072U);
    t4 = *((char **)t2);
    t2 = (t0 + 11312U);
    t5 = ieee_p_3620187407_sub_2255506239096166994_3965413181(IEEE_P_3620187407, t15, t4, t2, 1);
    t8 = (t15 + 12U);
    t16 = *((unsigned int *)t8);
    t17 = (1U * t16);
    t1 = (16U != t17);
    if (t1 == 1)
        goto LAB20;

LAB21:    t10 = (t0 + 6968);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t5, 16U);
    xsi_driver_first_trans_fast(t10);
    xsi_set_current_line(109, ng0);
    t2 = (t0 + 6904);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(110, ng0);
    t2 = (t0 + 4368U);
    t4 = *((char **)t2);
    t2 = (t0 + 4368U);
    t5 = *((char **)t2);
    t8 = ((IEEE_P_2592010699) + 4000);
    t10 = (t0 + 11296U);
    t11 = (t0 + 11296U);
    t2 = xsi_base_array_concat(t2, t15, t8, (char)97, t4, t10, (char)97, t5, t11, (char)101);
    t16 = (16U + 16U);
    t1 = (32U != t16);
    if (t1 == 1)
        goto LAB22;

LAB23:    t12 = (t0 + 7032);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t18 = (t14 + 56U);
    t19 = *((char **)t18);
    memcpy(t19, t2, 32U);
    xsi_driver_first_trans_delta(t12, 32U, 32U, 0LL);
    xsi_set_current_line(111, ng0);
    t2 = (t0 + 2632U);
    t4 = *((char **)t2);
    t20 = (3 - 3);
    t16 = (t20 * -1);
    t17 = (1U * t16);
    t21 = (0 + t17);
    t2 = (t4 + t21);
    t1 = *((unsigned char *)t2);
    t3 = (t1 == (unsigned char)2);
    if (t3 != 0)
        goto LAB24;

LAB26:    xsi_set_current_line(114, ng0);
    t2 = (t0 + 2632U);
    t4 = *((char **)t2);
    t16 = (3 - 2);
    t17 = (t16 * 1U);
    t21 = (0 + t17);
    t2 = (t4 + t21);
    t8 = ((IEEE_P_2592010699) + 4000);
    t10 = (t25 + 0U);
    t11 = (t10 + 0U);
    *((int *)t11) = 2;
    t11 = (t10 + 4U);
    *((int *)t11) = 0;
    t11 = (t10 + 8U);
    *((int *)t11) = -1;
    t20 = (0 - 2);
    t22 = (t20 * -1);
    t22 = (t22 + 1);
    t11 = (t10 + 12U);
    *((unsigned int *)t11) = t22;
    t5 = xsi_base_array_concat(t5, t15, t8, (char)99, (unsigned char)2, (char)97, t2, t25, (char)101);
    t11 = (t0 + 2792U);
    t12 = *((char **)t11);
    t13 = ((IEEE_P_2592010699) + 4000);
    t14 = (t0 + 11232U);
    t11 = xsi_base_array_concat(t11, t26, t13, (char)97, t5, t15, (char)97, t12, t14, (char)101);
    t18 = (t0 + 11485);
    t30 = ((IEEE_P_2592010699) + 4000);
    t32 = (t37 + 0U);
    t33 = (t32 + 0U);
    *((int *)t33) = 0;
    t33 = (t32 + 4U);
    *((int *)t33) = 3;
    t33 = (t32 + 8U);
    *((int *)t33) = 1;
    t28 = (3 - 0);
    t22 = (t28 * 1);
    t22 = (t22 + 1);
    t33 = (t32 + 12U);
    *((unsigned int *)t33) = t22;
    t27 = xsi_base_array_concat(t27, t31, t30, (char)97, t11, t26, (char)97, t18, t37, (char)101);
    t33 = (t0 + 4368U);
    t34 = *((char **)t33);
    t35 = ((IEEE_P_2592010699) + 4000);
    t36 = (t0 + 11296U);
    t33 = xsi_base_array_concat(t33, t39, t35, (char)97, t27, t31, (char)97, t34, t36, (char)101);
    t22 = (1U + 3U);
    t23 = (t22 + 8U);
    t24 = (t23 + 4U);
    t29 = (t24 + 16U);
    t1 = (32U != t29);
    if (t1 == 1)
        goto LAB29;

LAB30:    t38 = (t0 + 7032);
    t40 = (t38 + 56U);
    t41 = *((char **)t40);
    t46 = (t41 + 56U);
    t47 = *((char **)t46);
    memcpy(t47, t33, 32U);
    xsi_driver_first_trans_delta(t38, 0U, 32U, 0LL);

LAB25:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 7096);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((int *)t10) = 0;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(117, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(118, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(119, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(120, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB11:    xsi_set_current_line(123, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(124, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(125, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(126, ng0);
    t2 = (t0 + 7160);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((int *)t10) = 31;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(127, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB12:    xsi_set_current_line(130, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(131, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(132, ng0);
    t2 = (t0 + 3272U);
    t4 = *((char **)t2);
    t2 = (t0 + 3432U);
    t5 = *((char **)t2);
    t20 = *((int *)t5);
    t28 = (t20 - 31);
    t16 = (t28 * -1);
    xsi_vhdl_check_range_of_index(31, 0, -1, t20);
    t17 = (1U * t16);
    t2 = (t0 + 3592U);
    t8 = *((char **)t2);
    t42 = *((int *)t8);
    t50 = (t42 - 1);
    t21 = (t50 * -1);
    xsi_vhdl_check_range_of_index(1, 0, -1, t42);
    t22 = (32U * t21);
    t23 = (0 + t22);
    t24 = (t23 + t17);
    t2 = (t4 + t24);
    t1 = *((unsigned char *)t2);
    t10 = (t0 + 6648);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t1;
    xsi_driver_first_trans_fast_port(t10);
    xsi_set_current_line(133, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)4;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB13:    xsi_set_current_line(136, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(137, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(138, ng0);
    t2 = (t0 + 3272U);
    t4 = *((char **)t2);
    t2 = (t0 + 3432U);
    t5 = *((char **)t2);
    t20 = *((int *)t5);
    t28 = (t20 - 31);
    t16 = (t28 * -1);
    xsi_vhdl_check_range_of_index(31, 0, -1, t20);
    t17 = (1U * t16);
    t2 = (t0 + 3592U);
    t8 = *((char **)t2);
    t42 = *((int *)t8);
    t50 = (t42 - 1);
    t21 = (t50 * -1);
    xsi_vhdl_check_range_of_index(1, 0, -1, t42);
    t22 = (32U * t21);
    t23 = (0 + t22);
    t24 = (t23 + t17);
    t2 = (t4 + t24);
    t1 = *((unsigned char *)t2);
    t10 = (t0 + 6648);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t1;
    xsi_driver_first_trans_fast_port(t10);
    xsi_set_current_line(139, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)5;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB14:    xsi_set_current_line(144, ng0);
    t2 = (t0 + 3432U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t1 = (t20 != 0);
    if (t1 != 0)
        goto LAB31;

LAB33:    xsi_set_current_line(151, ng0);
    t2 = (t0 + 3592U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t1 = (t20 == 0);
    if (t1 != 0)
        goto LAB34;

LAB36:    xsi_set_current_line(158, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(159, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(160, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(161, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)7;
    xsi_driver_first_trans_fast(t2);

LAB35:
LAB32:    goto LAB8;

LAB15:    xsi_set_current_line(166, ng0);
    t2 = (t0 + 6520);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(167, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(168, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(169, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB16:    xsi_set_current_line(173, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)0;
    xsi_driver_first_trans_fast(t2);
    goto LAB8;

LAB17:    xsi_set_current_line(99, ng0);
    t2 = (t0 + 6840);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)1;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(100, ng0);
    t2 = (t0 + 6904);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB18;

LAB20:    xsi_size_not_matching(16U, t17, 0);
    goto LAB21;

LAB22:    xsi_size_not_matching(32U, t16, 0);
    goto LAB23;

LAB24:    xsi_set_current_line(112, ng0);
    t5 = (t0 + 4368U);
    t8 = *((char **)t5);
    t10 = ((IEEE_P_2592010699) + 4000);
    t11 = (t0 + 11296U);
    t5 = xsi_base_array_concat(t5, t15, t10, (char)97, t8, t11, (char)99, (unsigned char)2, (char)101);
    t12 = (t0 + 2632U);
    t13 = *((char **)t12);
    t22 = (3 - 2);
    t23 = (t22 * 1U);
    t24 = (0 + t23);
    t12 = (t13 + t24);
    t18 = ((IEEE_P_2592010699) + 4000);
    t19 = (t26 + 0U);
    t27 = (t19 + 0U);
    *((int *)t27) = 2;
    t27 = (t19 + 4U);
    *((int *)t27) = 0;
    t27 = (t19 + 8U);
    *((int *)t27) = -1;
    t28 = (0 - 2);
    t29 = (t28 * -1);
    t29 = (t29 + 1);
    t27 = (t19 + 12U);
    *((unsigned int *)t27) = t29;
    t14 = xsi_base_array_concat(t14, t25, t18, (char)97, t5, t15, (char)97, t12, t26, (char)101);
    t27 = (t0 + 2792U);
    t30 = *((char **)t27);
    t32 = ((IEEE_P_2592010699) + 4000);
    t33 = (t0 + 11232U);
    t27 = xsi_base_array_concat(t27, t31, t32, (char)97, t14, t25, (char)97, t30, t33, (char)101);
    t34 = (t0 + 11481);
    t38 = ((IEEE_P_2592010699) + 4000);
    t40 = (t39 + 0U);
    t41 = (t40 + 0U);
    *((int *)t41) = 0;
    t41 = (t40 + 4U);
    *((int *)t41) = 3;
    t41 = (t40 + 8U);
    *((int *)t41) = 1;
    t42 = (3 - 0);
    t29 = (t42 * 1);
    t29 = (t29 + 1);
    t41 = (t40 + 12U);
    *((unsigned int *)t41) = t29;
    t36 = xsi_base_array_concat(t36, t37, t38, (char)97, t27, t31, (char)97, t34, t39, (char)101);
    t29 = (16U + 1U);
    t43 = (t29 + 3U);
    t44 = (t43 + 8U);
    t45 = (t44 + 4U);
    t6 = (32U != t45);
    if (t6 == 1)
        goto LAB27;

LAB28:    t41 = (t0 + 7032);
    t46 = (t41 + 56U);
    t47 = *((char **)t46);
    t48 = (t47 + 56U);
    t49 = *((char **)t48);
    memcpy(t49, t36, 32U);
    xsi_driver_first_trans_delta(t41, 0U, 32U, 0LL);
    goto LAB25;

LAB27:    xsi_size_not_matching(32U, t45, 0);
    goto LAB28;

LAB29:    xsi_size_not_matching(32U, t29, 0);
    goto LAB30;

LAB31:    xsi_set_current_line(145, ng0);
    t2 = (t0 + 6520);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(146, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(147, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(148, ng0);
    t2 = (t0 + 3432U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t28 = (t20 - 1);
    t2 = (t0 + 7160);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    *((int *)t11) = t28;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(149, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast(t2);
    goto LAB32;

LAB34:    xsi_set_current_line(152, ng0);
    t2 = (t0 + 6520);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(153, ng0);
    t2 = (t0 + 6584);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(154, ng0);
    t2 = (t0 + 6648);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(155, ng0);
    t2 = (t0 + 3592U);
    t4 = *((char **)t2);
    t20 = *((int *)t4);
    t28 = (t20 + 1);
    t2 = (t0 + 7096);
    t5 = (t2 + 56U);
    t8 = *((char **)t5);
    t10 = (t8 + 56U);
    t11 = *((char **)t10);
    *((int *)t11) = t28;
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(156, ng0);
    t2 = (t0 + 6840);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t8 = (t5 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB35;

}


extern void work_a_1958242507_3212880686_init()
{
	static char *pe[] = {(void *)work_a_1958242507_3212880686_p_0,(void *)work_a_1958242507_3212880686_p_1,(void *)work_a_1958242507_3212880686_p_2};
	xsi_register_didat("work_a_1958242507_3212880686", "isim/mppc_dacs_wrapper_dac088s085_tb_isim_beh.exe.sim/work/a_1958242507_3212880686.didat");
	xsi_register_executes(pe);
}
