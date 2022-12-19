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
static const char *ng0 = "/home/ise/git/DC_backwards/DC_backwards/mppc_dacs_wrapper_dac088s085.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_2763492388968962707_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_2592010699_sub_3488546069778340532_503743352(char *, unsigned char , unsigned char );


static void work_a_3109191765_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(67, ng0);
    t1 = (t0 + 3632U);
    t2 = ieee_p_2592010699_sub_2763492388968962707_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 12768);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(68, ng0);
    t3 = (t0 + 3832U);
    t4 = *((char **)t3);
    t3 = (t0 + 13056);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t4, 4U);
    xsi_driver_first_trans_fast(t3);
    xsi_set_current_line(69, ng0);
    t1 = (t0 + 3992U);
    t3 = *((char **)t1);
    t1 = (t0 + 13120);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 4U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(70, ng0);
    t1 = (t0 + 4152U);
    t3 = *((char **)t1);
    t1 = (t0 + 13184);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t3, 8U);
    xsi_driver_first_trans_fast(t1);
    goto LAB3;

}

static void work_a_3109191765_3212880686_p_1(char *t0)
{
    char t5[16];
    char t21[16];
    char t36[16];
    char t51[16];
    char t66[16];
    char t81[16];
    char t96[16];
    char t111[16];
    char t126[16];
    char t141[16];
    char *t1;
    char *t2;
    char *t3;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned char t10;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t22;
    char *t23;
    int t24;
    unsigned char t25;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t37;
    char *t38;
    int t39;
    unsigned char t40;
    char *t42;
    char *t43;
    char *t44;
    char *t45;
    char *t46;
    char *t47;
    char *t48;
    char *t49;
    char *t52;
    char *t53;
    int t54;
    unsigned char t55;
    char *t57;
    char *t58;
    char *t59;
    char *t60;
    char *t61;
    char *t62;
    char *t63;
    char *t64;
    char *t67;
    char *t68;
    int t69;
    unsigned char t70;
    char *t72;
    char *t73;
    char *t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    char *t79;
    char *t82;
    char *t83;
    int t84;
    unsigned char t85;
    char *t87;
    char *t88;
    char *t89;
    char *t90;
    char *t91;
    char *t92;
    char *t93;
    char *t94;
    char *t97;
    char *t98;
    int t99;
    unsigned char t100;
    char *t102;
    char *t103;
    char *t104;
    char *t105;
    char *t106;
    char *t107;
    char *t108;
    char *t109;
    char *t112;
    char *t113;
    int t114;
    unsigned char t115;
    char *t117;
    char *t118;
    char *t119;
    char *t120;
    char *t121;
    char *t122;
    char *t123;
    char *t124;
    char *t127;
    char *t128;
    int t129;
    unsigned char t130;
    char *t132;
    char *t133;
    char *t134;
    char *t135;
    char *t136;
    char *t137;
    char *t138;
    char *t139;
    char *t142;
    char *t143;
    int t144;
    unsigned char t145;
    char *t147;
    char *t148;
    char *t149;
    char *t150;
    char *t151;
    char *t152;
    char *t154;
    char *t155;
    char *t156;
    char *t157;
    char *t158;
    char *t159;

LAB0:    xsi_set_current_line(88, ng0);
    t1 = (t0 + 5272U);
    t2 = *((char **)t1);
    t1 = (t0 + 20360U);
    t3 = (t0 + 20524);
    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 0;
    t7 = (t6 + 4U);
    *((int *)t7) = 3;
    t7 = (t6 + 8U);
    *((int *)t7) = 1;
    t8 = (3 - 0);
    t9 = (t8 * 1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t10 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t2, t1, t3, t5);
    if (t10 != 0)
        goto LAB3;

LAB4:    t17 = (t0 + 5272U);
    t18 = *((char **)t17);
    t17 = (t0 + 20360U);
    t19 = (t0 + 20538);
    t22 = (t21 + 0U);
    t23 = (t22 + 0U);
    *((int *)t23) = 0;
    t23 = (t22 + 4U);
    *((int *)t23) = 3;
    t23 = (t22 + 8U);
    *((int *)t23) = 1;
    t24 = (3 - 0);
    t9 = (t24 * 1);
    t9 = (t9 + 1);
    t23 = (t22 + 12U);
    *((unsigned int *)t23) = t9;
    t25 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t18, t17, t19, t21);
    if (t25 != 0)
        goto LAB5;

LAB6:    t32 = (t0 + 5272U);
    t33 = *((char **)t32);
    t32 = (t0 + 20360U);
    t34 = (t0 + 20552);
    t37 = (t36 + 0U);
    t38 = (t37 + 0U);
    *((int *)t38) = 0;
    t38 = (t37 + 4U);
    *((int *)t38) = 3;
    t38 = (t37 + 8U);
    *((int *)t38) = 1;
    t39 = (3 - 0);
    t9 = (t39 * 1);
    t9 = (t9 + 1);
    t38 = (t37 + 12U);
    *((unsigned int *)t38) = t9;
    t40 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t33, t32, t34, t36);
    if (t40 != 0)
        goto LAB7;

LAB8:    t47 = (t0 + 5272U);
    t48 = *((char **)t47);
    t47 = (t0 + 20360U);
    t49 = (t0 + 20566);
    t52 = (t51 + 0U);
    t53 = (t52 + 0U);
    *((int *)t53) = 0;
    t53 = (t52 + 4U);
    *((int *)t53) = 3;
    t53 = (t52 + 8U);
    *((int *)t53) = 1;
    t54 = (3 - 0);
    t9 = (t54 * 1);
    t9 = (t9 + 1);
    t53 = (t52 + 12U);
    *((unsigned int *)t53) = t9;
    t55 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t48, t47, t49, t51);
    if (t55 != 0)
        goto LAB9;

LAB10:    t62 = (t0 + 5272U);
    t63 = *((char **)t62);
    t62 = (t0 + 20360U);
    t64 = (t0 + 20580);
    t67 = (t66 + 0U);
    t68 = (t67 + 0U);
    *((int *)t68) = 0;
    t68 = (t67 + 4U);
    *((int *)t68) = 3;
    t68 = (t67 + 8U);
    *((int *)t68) = 1;
    t69 = (3 - 0);
    t9 = (t69 * 1);
    t9 = (t9 + 1);
    t68 = (t67 + 12U);
    *((unsigned int *)t68) = t9;
    t70 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t63, t62, t64, t66);
    if (t70 != 0)
        goto LAB11;

LAB12:    t77 = (t0 + 5272U);
    t78 = *((char **)t77);
    t77 = (t0 + 20360U);
    t79 = (t0 + 20594);
    t82 = (t81 + 0U);
    t83 = (t82 + 0U);
    *((int *)t83) = 0;
    t83 = (t82 + 4U);
    *((int *)t83) = 3;
    t83 = (t82 + 8U);
    *((int *)t83) = 1;
    t84 = (3 - 0);
    t9 = (t84 * 1);
    t9 = (t9 + 1);
    t83 = (t82 + 12U);
    *((unsigned int *)t83) = t9;
    t85 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t78, t77, t79, t81);
    if (t85 != 0)
        goto LAB13;

LAB14:    t92 = (t0 + 5272U);
    t93 = *((char **)t92);
    t92 = (t0 + 20360U);
    t94 = (t0 + 20608);
    t97 = (t96 + 0U);
    t98 = (t97 + 0U);
    *((int *)t98) = 0;
    t98 = (t97 + 4U);
    *((int *)t98) = 3;
    t98 = (t97 + 8U);
    *((int *)t98) = 1;
    t99 = (3 - 0);
    t9 = (t99 * 1);
    t9 = (t9 + 1);
    t98 = (t97 + 12U);
    *((unsigned int *)t98) = t9;
    t100 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t93, t92, t94, t96);
    if (t100 != 0)
        goto LAB15;

LAB16:    t107 = (t0 + 5272U);
    t108 = *((char **)t107);
    t107 = (t0 + 20360U);
    t109 = (t0 + 20622);
    t112 = (t111 + 0U);
    t113 = (t112 + 0U);
    *((int *)t113) = 0;
    t113 = (t112 + 4U);
    *((int *)t113) = 3;
    t113 = (t112 + 8U);
    *((int *)t113) = 1;
    t114 = (3 - 0);
    t9 = (t114 * 1);
    t9 = (t9 + 1);
    t113 = (t112 + 12U);
    *((unsigned int *)t113) = t9;
    t115 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t108, t107, t109, t111);
    if (t115 != 0)
        goto LAB17;

LAB18:    t122 = (t0 + 5272U);
    t123 = *((char **)t122);
    t122 = (t0 + 20360U);
    t124 = (t0 + 20636);
    t127 = (t126 + 0U);
    t128 = (t127 + 0U);
    *((int *)t128) = 0;
    t128 = (t127 + 4U);
    *((int *)t128) = 3;
    t128 = (t127 + 8U);
    *((int *)t128) = 1;
    t129 = (3 - 0);
    t9 = (t129 * 1);
    t9 = (t9 + 1);
    t128 = (t127 + 12U);
    *((unsigned int *)t128) = t9;
    t130 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t123, t122, t124, t126);
    if (t130 != 0)
        goto LAB19;

LAB20:    t137 = (t0 + 5272U);
    t138 = *((char **)t137);
    t137 = (t0 + 20360U);
    t139 = (t0 + 20650);
    t142 = (t141 + 0U);
    t143 = (t142 + 0U);
    *((int *)t143) = 0;
    t143 = (t142 + 4U);
    *((int *)t143) = 3;
    t143 = (t142 + 8U);
    *((int *)t143) = 1;
    t144 = (3 - 0);
    t9 = (t144 * 1);
    t9 = (t9 + 1);
    t143 = (t142 + 12U);
    *((unsigned int *)t143) = t9;
    t145 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t138, t137, t139, t141);
    if (t145 != 0)
        goto LAB21;

LAB22:
LAB23:    t152 = (t0 + 20664);
    t154 = (t0 + 13248);
    t155 = (t154 + 56U);
    t156 = *((char **)t155);
    t157 = (t156 + 56U);
    t158 = *((char **)t157);
    memcpy(t158, t152, 10U);
    xsi_driver_first_trans_fast(t154);

LAB2:    t159 = (t0 + 12784);
    *((int *)t159) = 1;

LAB1:    return;
LAB3:    t7 = (t0 + 20528);
    t12 = (t0 + 13248);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    memcpy(t16, t7, 10U);
    xsi_driver_first_trans_fast(t12);
    goto LAB2;

LAB5:    t23 = (t0 + 20542);
    t27 = (t0 + 13248);
    t28 = (t27 + 56U);
    t29 = *((char **)t28);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    memcpy(t31, t23, 10U);
    xsi_driver_first_trans_fast(t27);
    goto LAB2;

LAB7:    t38 = (t0 + 20556);
    t42 = (t0 + 13248);
    t43 = (t42 + 56U);
    t44 = *((char **)t43);
    t45 = (t44 + 56U);
    t46 = *((char **)t45);
    memcpy(t46, t38, 10U);
    xsi_driver_first_trans_fast(t42);
    goto LAB2;

LAB9:    t53 = (t0 + 20570);
    t57 = (t0 + 13248);
    t58 = (t57 + 56U);
    t59 = *((char **)t58);
    t60 = (t59 + 56U);
    t61 = *((char **)t60);
    memcpy(t61, t53, 10U);
    xsi_driver_first_trans_fast(t57);
    goto LAB2;

LAB11:    t68 = (t0 + 20584);
    t72 = (t0 + 13248);
    t73 = (t72 + 56U);
    t74 = *((char **)t73);
    t75 = (t74 + 56U);
    t76 = *((char **)t75);
    memcpy(t76, t68, 10U);
    xsi_driver_first_trans_fast(t72);
    goto LAB2;

LAB13:    t83 = (t0 + 20598);
    t87 = (t0 + 13248);
    t88 = (t87 + 56U);
    t89 = *((char **)t88);
    t90 = (t89 + 56U);
    t91 = *((char **)t90);
    memcpy(t91, t83, 10U);
    xsi_driver_first_trans_fast(t87);
    goto LAB2;

LAB15:    t98 = (t0 + 20612);
    t102 = (t0 + 13248);
    t103 = (t102 + 56U);
    t104 = *((char **)t103);
    t105 = (t104 + 56U);
    t106 = *((char **)t105);
    memcpy(t106, t98, 10U);
    xsi_driver_first_trans_fast(t102);
    goto LAB2;

LAB17:    t113 = (t0 + 20626);
    t117 = (t0 + 13248);
    t118 = (t117 + 56U);
    t119 = *((char **)t118);
    t120 = (t119 + 56U);
    t121 = *((char **)t120);
    memcpy(t121, t113, 10U);
    xsi_driver_first_trans_fast(t117);
    goto LAB2;

LAB19:    t128 = (t0 + 20640);
    t132 = (t0 + 13248);
    t133 = (t132 + 56U);
    t134 = *((char **)t133);
    t135 = (t134 + 56U);
    t136 = *((char **)t135);
    memcpy(t136, t128, 10U);
    xsi_driver_first_trans_fast(t132);
    goto LAB2;

LAB21:    t143 = (t0 + 20654);
    t147 = (t0 + 13248);
    t148 = (t147 + 56U);
    t149 = *((char **)t148);
    t150 = (t149 + 56U);
    t151 = *((char **)t150);
    memcpy(t151, t143, 10U);
    xsi_driver_first_trans_fast(t147);
    goto LAB2;

LAB24:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(101, ng0);

LAB3:    t1 = (t0 + 5912U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 13312);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 12800);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(102, ng0);

LAB3:    t1 = (t0 + 6072U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 13376);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 12816);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7168U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13440);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 9U, 1, 0LL);

LAB2:    t18 = (t0 + 12832);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_5(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7288U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13504);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 8U, 1, 0LL);

LAB2:    t18 = (t0 + 12848);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_6(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7408U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13568);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 7U, 1, 0LL);

LAB2:    t18 = (t0 + 12864);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_7(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7528U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13632);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 6U, 1, 0LL);

LAB2:    t18 = (t0 + 12880);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_8(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7648U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13696);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 5U, 1, 0LL);

LAB2:    t18 = (t0 + 12896);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_9(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7768U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13760);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 4U, 1, 0LL);

LAB2:    t18 = (t0 + 12912);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_10(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 7888U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13824);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 3U, 1, 0LL);

LAB2:    t18 = (t0 + 12928);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_11(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 8008U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13888);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 2U, 1, 0LL);

LAB2:    t18 = (t0 + 12944);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_12(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 8128U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 13952);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 1U, 1, 0LL);

LAB2:    t18 = (t0 + 12960);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3109191765_3212880686_p_13(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    int t4;
    int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned char t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    xsi_set_current_line(105, ng0);

LAB3:    t1 = (t0 + 5752U);
    t2 = *((char **)t1);
    t1 = (t0 + 8248U);
    t3 = *((char **)t1);
    t4 = *((int *)t3);
    t5 = (t4 - 9);
    t6 = (t5 * -1);
    t7 = (1U * t6);
    t8 = (0 + t7);
    t1 = (t2 + t8);
    t9 = *((unsigned char *)t1);
    t10 = (t0 + 6232U);
    t11 = *((char **)t10);
    t12 = *((unsigned char *)t11);
    t13 = ieee_p_2592010699_sub_3488546069778340532_503743352(IEEE_P_2592010699, t9, t12);
    t10 = (t0 + 14016);
    t14 = (t10 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    *((unsigned char *)t17) = t13;
    xsi_driver_first_trans_delta(t10, 0U, 1, 0LL);

LAB2:    t18 = (t0 + 12976);
    *((int *)t18) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_3109191765_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3109191765_3212880686_p_0,(void *)work_a_3109191765_3212880686_p_1,(void *)work_a_3109191765_3212880686_p_2,(void *)work_a_3109191765_3212880686_p_3,(void *)work_a_3109191765_3212880686_p_4,(void *)work_a_3109191765_3212880686_p_5,(void *)work_a_3109191765_3212880686_p_6,(void *)work_a_3109191765_3212880686_p_7,(void *)work_a_3109191765_3212880686_p_8,(void *)work_a_3109191765_3212880686_p_9,(void *)work_a_3109191765_3212880686_p_10,(void *)work_a_3109191765_3212880686_p_11,(void *)work_a_3109191765_3212880686_p_12,(void *)work_a_3109191765_3212880686_p_13};
	xsi_register_didat("work_a_3109191765_3212880686", "isim/mppc_dacs_wrapper_dac088s085_tb_isim_beh.exe.sim/work/a_3109191765_3212880686.didat");
	xsi_register_executes(pe);
}
