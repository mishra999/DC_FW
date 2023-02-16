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
extern char *STD_STANDARD;
extern char *IEEE_P_1242562249;

int ieee_p_1242562249_sub_1871261289446890672_1035706684(char *, char *, char *);


void work_p_1711965120_sub_2284603028568274775_3663013896(char *t0, char *t1, char *t2, char *t3, unsigned int t4, unsigned int t5, char *t6, char *t7, int t8)
{
    char t9[368];
    char t10[16];
    char t14[8];
    char t20[8];
    char t26[8];
    char *t11;
    char *t12;
    char *t13;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t27;
    char *t28;
    char *t29;
    unsigned char t30;
    char *t31;
    char *t32;
    unsigned int t33;
    char *t34;
    char *t35;
    int t36;
    int t37;
    int t38;
    int t39;
    unsigned int t40;
    char *t41;
    int t42;
    char *t43;
    char *t44;
    char *t45;
    char *t46;
    char *t47;
    int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    char *t52;
    char *t53;
    char *t54;
    int t55;
    int t56;
    int t57;
    unsigned int t58;
    unsigned int t59;
    char *t60;
    int t61;
    int t62;
    int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned char t66;
    int t67;
    char *t68;
    char *t69;
    int t70;
    int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    int t75;
    char *t76;
    char *t77;
    int t78;
    int t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    char *t84;
    char *t85;
    char *t86;
    char *t87;
    char *t88;
    int t89;
    int t90;
    int t91;
    unsigned int t92;
    unsigned int t93;
    char *t94;
    int t95;
    int t96;
    int t97;
    unsigned int t98;
    unsigned int t99;

LAB0:    t11 = (t9 + 4U);
    t12 = ((STD_STANDARD) + 384);
    t13 = (t11 + 88U);
    *((char **)t13) = t12;
    t15 = (t11 + 56U);
    *((char **)t15) = t14;
    *((int *)t14) = 0;
    t16 = (t11 + 80U);
    *((unsigned int *)t16) = 4U;
    t17 = (t9 + 124U);
    t18 = ((STD_STANDARD) + 384);
    t19 = (t17 + 88U);
    *((char **)t19) = t18;
    t21 = (t17 + 56U);
    *((char **)t21) = t20;
    *((int *)t20) = 0;
    t22 = (t17 + 80U);
    *((unsigned int *)t22) = 4U;
    t23 = (t9 + 244U);
    t24 = ((STD_STANDARD) + 384);
    t25 = (t23 + 88U);
    *((char **)t25) = t24;
    t27 = (t23 + 56U);
    *((char **)t27) = t26;
    *((int *)t26) = 0;
    t28 = (t23 + 80U);
    *((unsigned int *)t28) = 4U;
    t29 = (t10 + 4U);
    t30 = (t2 != 0);
    if (t30 == 1)
        goto LAB3;

LAB2:    t31 = (t10 + 12U);
    *((int *)t31) = t8;
    t32 = (t7 + 12U);
    t33 = *((unsigned int *)t32);
    t34 = (t11 + 56U);
    t35 = *((char **)t34);
    t34 = (t35 + 0);
    *((int *)t34) = t33;
    t12 = (t0 + 3144);
    t13 = xsi_record_get_element_type(t12, 1);
    t15 = (t13 + 72U);
    t16 = *((char **)t15);
    t18 = (t16 + 12U);
    t33 = *((unsigned int *)t18);
    t19 = (t17 + 56U);
    t21 = *((char **)t19);
    t19 = (t21 + 0);
    *((int *)t19) = t33;
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t36 = *((int *)t13);
    t12 = (t17 + 56U);
    t15 = *((char **)t12);
    t37 = *((int *)t15);
    t30 = (t36 < t37);
    if (t30 != 0)
        goto LAB4;

LAB6:    t12 = (t17 + 56U);
    t13 = *((char **)t12);
    t36 = *((int *)t13);
    t12 = (t23 + 56U);
    t15 = *((char **)t12);
    t12 = (t15 + 0);
    *((int *)t12) = t36;

LAB5:    t33 = (0 + 0U);
    t12 = (t2 + t33);
    t13 = (t0 + 3144);
    t15 = xsi_record_get_element_type(t13, 0);
    t16 = (t15 + 72U);
    t18 = *((char **)t16);
    t36 = ieee_p_1242562249_sub_1871261289446890672_1035706684(IEEE_P_1242562249, t12, t18);
    t30 = (t36 == t8);
    if (t30 != 0)
        goto LAB7;

LAB9:
LAB8:
LAB1:    return;
LAB3:    *((char **)t29) = t2;
    goto LAB2;

LAB4:    t12 = (t11 + 56U);
    t16 = *((char **)t12);
    t38 = *((int *)t16);
    t12 = (t23 + 56U);
    t18 = *((char **)t12);
    t12 = (t18 + 0);
    *((int *)t12) = t38;
    goto LAB5;

LAB7:    t19 = (t0 + 3144);
    t21 = xsi_record_get_element_type(t19, 1);
    t22 = (t21 + 72U);
    t24 = *((char **)t22);
    t25 = (t24 + 0U);
    t37 = *((int *)t25);
    t27 = (t23 + 56U);
    t28 = *((char **)t27);
    t38 = *((int *)t28);
    t39 = (t38 - 1);
    t40 = (t37 - t39);
    t27 = (t0 + 3144);
    t32 = xsi_record_get_element_type(t27, 1);
    t34 = (t32 + 72U);
    t35 = *((char **)t34);
    t41 = (t35 + 4U);
    t42 = *((int *)t41);
    t43 = (t0 + 3144);
    t44 = xsi_record_get_element_type(t43, 1);
    t45 = (t44 + 72U);
    t46 = *((char **)t45);
    t47 = (t46 + 8U);
    t48 = *((int *)t47);
    xsi_vhdl_check_range_of_slice(t37, t42, t48, t39, 0, -1);
    t49 = (t40 * 1U);
    t50 = (0 + 16U);
    t51 = (t50 + t49);
    t52 = (t2 + t51);
    t53 = (t23 + 56U);
    t54 = *((char **)t53);
    t55 = *((int *)t54);
    t56 = (t55 - 1);
    t57 = (0 - t56);
    t58 = (t57 * -1);
    t58 = (t58 + 1);
    t59 = (1U * t58);
    t53 = (t23 + 56U);
    t60 = *((char **)t53);
    t61 = *((int *)t60);
    t62 = (t61 - 1);
    t63 = (0 - t62);
    t64 = (t63 * -1);
    t64 = (t64 + 1);
    t65 = (1U * t64);
    t66 = (t59 != t65);
    if (t66 == 1)
        goto LAB10;

LAB11:    t53 = (t7 + 0U);
    t67 = *((int *)t53);
    t68 = (t23 + 56U);
    t69 = *((char **)t68);
    t70 = *((int *)t69);
    t71 = (t70 - 1);
    t72 = (t67 - t71);
    t73 = (1U * t72);
    t74 = (0 + t73);
    t68 = (t7 + 0U);
    t75 = *((int *)t68);
    t76 = (t23 + 56U);
    t77 = *((char **)t76);
    t78 = *((int *)t77);
    t79 = (t78 - 1);
    t80 = (t75 - t79);
    t81 = (1U * t80);
    t82 = (0 + t81);
    t83 = (t82 + t4);
    t76 = (t6 + 56U);
    t84 = *((char **)t76);
    t85 = (t84 + 56U);
    t86 = *((char **)t85);
    t87 = (t23 + 56U);
    t88 = *((char **)t87);
    t89 = *((int *)t88);
    t90 = (t89 - 1);
    t91 = (0 - t90);
    t92 = (t91 * -1);
    t92 = (t92 + 1);
    t93 = (1U * t92);
    memcpy(t86, t52, t93);
    t87 = (t23 + 56U);
    t94 = *((char **)t87);
    t95 = *((int *)t94);
    t96 = (t95 - 1);
    t97 = (0 - t96);
    t98 = (t97 * -1);
    t98 = (t98 + 1);
    t99 = (1U * t98);
    xsi_driver_first_trans_delta(t6, t83, t99, 0LL);
    goto LAB8;

LAB10:    xsi_size_not_matching(t59, t65, 0);
    goto LAB11;

}


extern void work_p_1711965120_init()
{
	static char *se[] = {(void *)work_p_1711965120_sub_2284603028568274775_3663013896};
	xsi_register_didat("work_p_1711965120", "isim/TX_DAC_control_w_regInterface_tb_isim_beh.exe.sim/work/p_1711965120.didat");
	xsi_register_subprogram_executes(se);
}
