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
static const char *ng1 = "Function if_then_else ended without a return statement";
extern char *IEEE_P_2592010699;
static const char *ng3 = "Function map_ready_valid ended without a return statement";

unsigned char ieee_p_2592010699_sub_3488768496604610246_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_374109322130769762_503743352(char *, unsigned char );


int xilinxcorelib_a_2017763730_3212880686_sub_4998376546216353788_3057020925(char *t1, unsigned char t2, int t3, int t4)
{
    char t5[128];
    char t6[16];
    char t10[8];
    int t0;
    char *t7;
    char *t8;
    char *t9;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    int t19;

LAB0:    t7 = (t5 + 4U);
    t8 = ((STD_STANDARD) + 384);
    t9 = (t7 + 88U);
    *((char **)t9) = t8;
    t11 = (t7 + 56U);
    *((char **)t11) = t10;
    *((int *)t10) = 0;
    t12 = (t7 + 80U);
    *((unsigned int *)t12) = 4U;
    t13 = (t6 + 4U);
    *((unsigned char *)t13) = t2;
    t14 = (t6 + 5U);
    *((int *)t14) = t3;
    t15 = (t6 + 9U);
    *((int *)t15) = t4;
    t16 = (!(t2));
    if (t16 != 0)
        goto LAB2;

LAB4:    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t8 = (t9 + 0);
    *((int *)t8) = t3;

LAB3:    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t19 = *((int *)t9);
    t0 = t19;

LAB1:    return t0;
LAB2:    t17 = (t7 + 56U);
    t18 = *((char **)t17);
    t17 = (t18 + 0);
    *((int *)t17) = t4;
    goto LAB3;

LAB5:;
}

char *xilinxcorelib_a_2017763730_3212880686_sub_4497644195088856487_3057020925(char *t1, char *t2, unsigned char t3, char *t4, char *t5, char *t6, char *t7)
{
    char t9[40];
    char *t0;
    char *t10;
    char *t11;
    unsigned char t12;
    char *t13;
    char *t14;
    unsigned char t15;
    char *t16;
    unsigned char t17;
    char *t18;
    unsigned int t19;
    char *t20;
    int t21;
    char *t22;
    int t23;
    char *t24;
    int t25;
    char *t26;
    char *t27;
    int t28;
    unsigned int t29;

LAB0:    t10 = (t9 + 4U);
    *((unsigned char *)t10) = t3;
    t11 = (t9 + 5U);
    t12 = (t4 != 0);
    if (t12 == 1)
        goto LAB3;

LAB2:    t13 = (t9 + 13U);
    *((char **)t13) = t5;
    t14 = (t9 + 21U);
    t15 = (t6 != 0);
    if (t15 == 1)
        goto LAB5;

LAB4:    t16 = (t9 + 29U);
    *((char **)t16) = t7;
    t17 = (!(t3));
    if (t17 != 0)
        goto LAB6;

LAB8:    t18 = (t5 + 12U);
    t19 = *((unsigned int *)t18);
    t19 = (t19 * 1U);
    t0 = xsi_get_transient_memory(t19);
    memcpy(t0, t4, t19);
    t20 = (t5 + 0U);
    t21 = *((int *)t20);
    t22 = (t5 + 4U);
    t23 = *((int *)t22);
    t24 = (t5 + 8U);
    t25 = *((int *)t24);
    t26 = (t2 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = t21;
    t27 = (t26 + 4U);
    *((int *)t27) = t23;
    t27 = (t26 + 8U);
    *((int *)t27) = t25;
    t28 = (t23 - t21);
    t29 = (t28 * t25);
    t29 = (t29 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t29;

LAB1:    return t0;
LAB3:    *((char **)t11) = t4;
    goto LAB2;

LAB5:    *((char **)t14) = t6;
    goto LAB4;

LAB6:    t18 = (t7 + 12U);
    t19 = *((unsigned int *)t18);
    t19 = (t19 * 1U);
    t0 = xsi_get_transient_memory(t19);
    memcpy(t0, t6, t19);
    t20 = (t7 + 0U);
    t21 = *((int *)t20);
    t22 = (t7 + 4U);
    t23 = *((int *)t22);
    t24 = (t7 + 8U);
    t25 = *((int *)t24);
    t26 = (t2 + 0U);
    t27 = (t26 + 0U);
    *((int *)t27) = t21;
    t27 = (t26 + 4U);
    *((int *)t27) = t23;
    t27 = (t26 + 8U);
    *((int *)t27) = t25;
    t28 = (t23 - t21);
    t29 = (t28 * t25);
    t29 = (t29 + 1);
    t27 = (t26 + 12U);
    *((unsigned int *)t27) = t29;
    goto LAB1;

LAB7:    xsi_error(ng1);
    t0 = 0;
    goto LAB1;

LAB9:    goto LAB7;

LAB10:    goto LAB7;

}

unsigned char xilinxcorelib_a_2017763730_3212880686_sub_1978974429435499120_3057020925(char *t1, int t2, unsigned char t3, unsigned char t4, unsigned char t5)
{
    char t7[16];
    unsigned char t0;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    unsigned char t12;
    unsigned char t13;

LAB0:    t8 = (t7 + 4U);
    *((int *)t8) = t2;
    t9 = (t7 + 8U);
    *((unsigned char *)t9) = t3;
    t10 = (t7 + 9U);
    *((unsigned char *)t10) = t4;
    t11 = (t7 + 10U);
    *((unsigned char *)t11) = t5;
    t12 = (t2 == 5);
    if (t12 != 0)
        goto LAB2;

LAB4:    t12 = (t2 == 6);
    if (t12 != 0)
        goto LAB6;

LAB7:    t12 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t5);
    t0 = t12;

LAB1:    return t0;
LAB2:    t13 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t0 = t13;
    goto LAB1;

LAB3:    xsi_error(ng3);
    t0 = 0;
    goto LAB1;

LAB5:    goto LAB3;

LAB6:    t13 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t4);
    t0 = t13;
    goto LAB1;

LAB8:    goto LAB3;

LAB9:    goto LAB3;

}

static void xilinxcorelib_a_2017763730_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:
LAB3:    t1 = (t0 + 9384U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t1 = (t0 + 71600);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t1);

LAB2:    t9 = (t0 + 71344);
    *((int *)t9) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:
LAB3:    t1 = (t0 + 24584U);
    t2 = *((char **)t1);
    t1 = (t0 + 71664);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 32U);
    xsi_driver_first_trans_delta(t1, 0U, 32U, 0LL);

LAB2:    t7 = (t0 + 71360);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_2(char *t0)
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

LAB0:
LAB3:    t1 = (t0 + 40104U);
    t2 = *((char **)t1);
    t3 = (32 - 1);
    t4 = (31 - t3);
    t5 = (t4 * 1U);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = (t0 + 71728);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 32U);
    xsi_driver_first_trans_fast_port(t7);

LAB2:    t12 = (t0 + 71376);
    *((int *)t12) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_3(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:
LAB3:    t1 = (t0 + 24264U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 71792);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);

LAB2:    t8 = (t0 + 71392);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_4(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:
LAB3:    t1 = (t0 + 25864U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 71856);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);

LAB2:    t8 = (t0 + 71408);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_5(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    t1 = (0 == 0);
    if (t1 != 0)
        goto LAB3;

LAB4:
LAB5:    t9 = (t0 + 40904U);
    t10 = *((char **)t9);
    t11 = *((unsigned char *)t10);
    t9 = (t0 + 9704U);
    t12 = *((char **)t9);
    t13 = *((unsigned char *)t12);
    t14 = ieee_p_2592010699_sub_3488768496604610246_503743352(IEEE_P_2592010699, t11, t13);
    t9 = (t0 + 71920);
    t15 = (t9 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = t14;
    xsi_driver_first_trans_fast(t9);

LAB2:    t19 = (t0 + 71424);
    *((int *)t19) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 40904U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t2 = (t0 + 71920);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t2);
    goto LAB2;

LAB6:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_6(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    t1 = (0 == 0);
    if (t1 != 0)
        goto LAB3;

LAB4:
LAB5:    t9 = (t0 + 41064U);
    t10 = *((char **)t9);
    t11 = *((unsigned char *)t10);
    t9 = (t0 + 9544U);
    t12 = *((char **)t9);
    t13 = *((unsigned char *)t12);
    t14 = ieee_p_2592010699_sub_3488768496604610246_503743352(IEEE_P_2592010699, t11, t13);
    t9 = (t0 + 71984);
    t15 = (t9 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    *((unsigned char *)t18) = t14;
    xsi_driver_first_trans_fast(t9);

LAB2:    t19 = (t0 + 71440);
    *((int *)t19) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 41064U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t2 = (t0 + 71984);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t2);
    goto LAB2;

LAB6:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_7(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:
LAB3:    t1 = (t0 + 40264U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t1 = (t0 + 72048);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t1);

LAB2:    t9 = (t0 + 71456);
    *((int *)t9) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_8(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:
LAB3:    t1 = (t0 + 40424U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = ieee_p_2592010699_sub_374109322130769762_503743352(IEEE_P_2592010699, t3);
    t1 = (t0 + 72112);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t1);

LAB2:    t9 = (t0 + 71472);
    *((int *)t9) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_9(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:
LAB3:    t1 = (t0 + 40584U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 72176);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 71488);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_10(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:
LAB3:    t1 = (t0 + 40744U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 72240);
    t4 = (t1 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 71504);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void xilinxcorelib_a_2017763730_3212880686_p_11(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:
LAB3:    t1 = (t0 + 41224U);
    t2 = *((char **)t1);
    t1 = (t0 + 72304);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 6U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 71520);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void xilinxcorelib_a_2017763730_3212880686_init()
{
	static char *pe[] = {(void *)xilinxcorelib_a_2017763730_3212880686_p_0,(void *)xilinxcorelib_a_2017763730_3212880686_p_1,(void *)xilinxcorelib_a_2017763730_3212880686_p_2,(void *)xilinxcorelib_a_2017763730_3212880686_p_3,(void *)xilinxcorelib_a_2017763730_3212880686_p_4,(void *)xilinxcorelib_a_2017763730_3212880686_p_5,(void *)xilinxcorelib_a_2017763730_3212880686_p_6,(void *)xilinxcorelib_a_2017763730_3212880686_p_7,(void *)xilinxcorelib_a_2017763730_3212880686_p_8,(void *)xilinxcorelib_a_2017763730_3212880686_p_9,(void *)xilinxcorelib_a_2017763730_3212880686_p_10,(void *)xilinxcorelib_a_2017763730_3212880686_p_11};
	static char *se[] = {(void *)xilinxcorelib_a_2017763730_3212880686_sub_4998376546216353788_3057020925,(void *)xilinxcorelib_a_2017763730_3212880686_sub_4497644195088856487_3057020925,(void *)xilinxcorelib_a_2017763730_3212880686_sub_1978974429435499120_3057020925};
	xsi_register_didat("xilinxcorelib_a_2017763730_3212880686", "isim/TargetX_data_tb_isim_beh.exe.sim/xilinxcorelib/a_2017763730_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
