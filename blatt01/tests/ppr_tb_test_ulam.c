/**
 * @file
 * Dieses Modul enthaelt Testfaelle, mit denen die Berechnung mit der
 * Ulam-Funktion ueberprueft wird.
 *
 * @author  Ulrike Griefahn
 * @date    2014-01-31
 */


/* ============================================================================
 * Header-Dateien
 * ========================================================================= */

#include <stdio.h>
#include <stdlib.h>

#ifdef TESTBENCH
#include "ppr_tb_logging.h"
#endif


/* ===========================================================================
 * Prototypen der Aufgabenstellung
 * ======================================================================== */

extern int ulam_max(int a_0);
extern int ulam_twins(int limit);
extern int ulam_multiples(int limit, int number);


/* ===========================================================================
 * Prototypen der privaten Funktionen
 * ======================================================================== */

void ppr_tb_print_ok(void);

/**
 * Vergleicht das gelieferte Ergebnis mit dem erwarteten Ergebnis 
 * (Ist-Soll-Vergleich) und gibt abhaengig davon, ob der Vergleich eine 
 * Abweichung ergeben hat oder nicht, eine entsprechende Meldung aus.
 *
 * @param testcase       Name des Testfalls
 * @param fct            Name der Funktion, die aufgerufen wurde.
 * @param a0_bzw_limit   abhaengig vom Namen der Funktion (1-ter Parameter)
 *                       handelt es sich um a0 oder limit
 * @param number         gibt die Anzahl der gesuchten Mehrlinge an, falls
 *                       der Wert kleiner -1 ist, andernfalls wird der Parameter
 *                       ignoriert
 * @param expected       das erwartete Ergebnis (Sollwert)
 * @param result         das gelieferte Ergebnis (Istwert)
 *
 * @return               true, falls das gelieferte Ergebnis
 *                       (Istwert) mit dem erwarteten Ergebnis (Sollwert)
 *                       uebereinstimmt. false, sonst
 */
static void ppr_tb_assert_equal(char *testcase, char *fct, int a0_bzw_limit,
                                int number, int target_result,
                                int actual_result);


/* ============================================================================
 * Funktionsdefinitionen
 * ========================================================================= */

/* ----------------------------------------------------------------------------
 * Funktion: ppr_tb_print_ok
 * ------------------------------------------------------------------------- */
void ppr_tb_print_ok(void)
{   
    printf("[OK]\n\n");
    fflush(stdout);
              
#ifdef TESTBENCH
    ppr_tb_log_assert();
#endif
}

/* ----------------------------------------------------------------------------
 * Funktion: ppr_tb_testUlam_max
 * ------------------------------------------------------------------------- */
void ppr_tb_testUlam_max()
{
    int a0;
    int expected;
    int result;
    char *msg = "testUlam_max (test_ulam)";
    char *fct = "ulam_max";
    
    printf("========================================================\n");
    printf("Ueberpruefe Testfaelle ( U L A M _ M A X ): ");
    printf("\n========================================================\n");
    printf("Testfall 1 ulam_max: Ungueltiger Wert fuer Parameter a_0\n");
    fflush(stdout);
    
    /* ulam_max(-1) = -1 */
    a0 = -1;
    expected = -1;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
    
    /* ulam_max(0) = -1 */
    a0 = 0;
    expected = -1;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);

    printf("Testfall 2 ulam_max: Gueltige Werte fuer Parameter a_0\n");
    fflush(stdout);
    
    /* ulam_max(1) = 1 */
    a0 = 1;
    expected = 1;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
    
    /* ulam_max(2) = 2 */
    a0 = 2;
    expected = 2;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
    
    /* ulam_max(3) = 16 */
    a0 = 3;
    expected = 16;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
    
    /* ulam_max(4) = 4 */
    a0 = 4;
    expected = 4;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
    
    /* ulam_max(5) = 16 */
    a0 = 5;
    expected = 16;
    result = ulam_max(a0);
    ppr_tb_assert_equal(msg, fct, a0, -2, expected, result);
}

/* ----------------------------------------------------------------------------
 * Funktion: ppr_tb_testUlam_twins
 * ------------------------------------------------------------------------- */
void ppr_tb_testUlam_twins()
{
    int limit;
    int expected;
    int result;
    
    char *msg = "testUlam_twins (test_ulam)";
    char *fct = "ulam_twins";
    
    printf("========================================================\n");
    printf("Ueberpruefe Testfaelle ( U L A M _ T W I N S ): ");
    printf("\n========================================================\n");
    printf("Testfall 3 ulam_twins: Ungueltiger Wert fuer Parameter limit\n");
    fflush(stdout);
    
    /* ulam_twins(0) = -1 */
    limit = 0;
    expected = -1;
    result = ulam_twins(limit);
    ppr_tb_assert_equal(msg, fct, limit, -2, expected, result);

    printf("Testfall 4 ulam_twins: "
           "ULAM-Zwilling nicht vollstaendig im Intervall enthalten\n");
    fflush(stdout);
    
    /* ulam_twins(5) = -1 */
    limit = 5;
    expected = -1;
    result = ulam_twins(limit);
    ppr_tb_assert_equal(msg, fct, limit, -2, expected, result);

    printf("Testfall 5 ulam_twins: "
           "Gueltige Werte fuer Parameter limit\n");
    fflush(stdout);
    
    /* ulam_twins(6) = 5 */
    limit = 6;
    expected = 5;
    result = ulam_twins(limit);
    ppr_tb_assert_equal(msg, fct, limit, -2, expected, result);
}

/* ----------------------------------------------------------------------------
 * Funktion: ppr_tb_testUlam_multiples
 * ------------------------------------------------------------------------- */
void ppr_tb_testUlam_multiples()
{
    int limit;
    int number;
    int expected;
    int result;
    
    char *msg = "testUlam_multiples (test_ulam)";
    char *fct = "ulam_multiples";
    
    printf("========================================================\n");
    printf("Ueberpruefe Testfaelle ( U L A M _ M U L T I P L E S ): ");
    printf("\n========================================================\n");
    printf("Testfall 6 ulam_multiples: "
           "Ungueltiger Wert fuer Parameter limit\n");
    fflush(stdout);

    /* ulam_multiples(0, 2) = -1 */
    limit = 0;
    number = 2;
    expected = -1;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    printf("Testfall 7 ulam_multiples: "
           "Ungueltiger Wert fuer Parameter number\n");
    fflush(stdout);

    /* ulam_multiples(10, 0) = -1 */
    limit = 10;
    number = 0;
    expected = -1;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    printf("Testfall 8 ulam_multiples: "
           "Mehrling fuer number=2 nicht vollstaendig im Intervall enthalten\n");
    fflush(stdout);

    /* ulam_multiples(5, 2) = -1 */
    limit = 5;
    number = 2;
    expected = -1;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    printf("Testfall 9 ulam_multiples: "
           "Mehrling fuer number=4 nicht vollstaendig im Intervall enthalten\n");
    fflush(stdout);

    /* ulam_multiples(109, 4) = -1 */
    limit = 109;
    number = 4;
    expected = -1;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    printf("Testfall 10 ulam_multiples: "
           "Gueltige Werte fuer Parameter limit und number\n");
    fflush(stdout);

    /* ulam_multiples(110, 4) = 107 */
    limit = 110;
    number = 4;
    expected = 107;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    /* ulam_multiples(111, 4) = 108 */
    limit = 111;
    number = 4;
    expected = 108;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    /* ulam_multiples(1000, 2) = 982 */
    limit = 1000;
    number = 2;
    expected = 982;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
    
    /* ulam_multiples(391, 2) = 386 */
    limit = 391;
    number = 6;
    expected = 386;
    result = ulam_multiples(limit, number);
    ppr_tb_assert_equal(msg, fct, limit, number, expected, result);
}

/* ----------------------------------------------------------------------------
 * Funktion: ppr_tb_assert_equal
 * ------------------------------------------------------------------------- */
static void ppr_tb_assert_equal(char *testcase, char *function,
                                int a0_bzw_limit, int number, 
                                int expected, int result)
{    
    if (result == expected)
    {
        ppr_tb_print_ok();
    }
    else
    {
        printf("[ERROR]\n");

        if (number >= -1)
        {
            printf("   Aufruf von %s(%d, %d)\n", 
                   function, a0_bzw_limit, number);
        }
        else
        {
            printf("   Aufruf von %s(%d)\n", function, a0_bzw_limit);
        }
        printf("   expected:<[\n");
        printf("   %d\n", expected);
        printf("   ]> but was:<[\n");
        printf("   %d", result);
        printf("\n   ]>\n");
        fflush(stdout);

#ifndef TESTBENCH
        printf("%%TEST_FAILED%% time=0 testname=%s "
               "message=expected: %d, but was %d\n", 
               testcase, expected, result);
#endif
    }
}

/* ----------------------------------------------------------------------------
 * Funktion: main
 * ------------------------------------------------------------------------- */
#ifndef TESTBENCH
int main(void)
{   
    printf("%%SUITE_STARTING%% test_ulam\n");
    printf("%%SUITE_STARTED%%\n");

    printf("%%TEST_STARTED%%  testUlam_max (test_ulam)\n");
    ppr_tb_testUlam_max();
    printf("%%TEST_FINISHED%% time=0 testUlam_max (test_ulam)\n");

    printf("%%TEST_STARTED%%  testUlam_twins (test_ulam)\n");
    ppr_tb_testUlam_twins();
    printf("%%TEST_FINISHED%% time=0 testUlam_twins (test_ulam)\n");

    printf("%%TEST_STARTED%%  testUlam_multiples (test_ulam)\n");
    ppr_tb_testUlam_multiples();
    printf("%%TEST_FINISHED%% time=0 testUlam_multiples (test_ulam)\n");

    printf("%%SUITE_FINISHED%% time=0\n");
    
    return (EXIT_SUCCESS);
}
#endif 

#ifdef TESTBENCH
int main(int argc, char **argv)
{  
    ppr_tb_write_total_assert(18);

    ppr_tb_testUlam_max();
    ppr_tb_testUlam_twins();
    ppr_tb_testUlam_multiples();
    
    ppr_tb_write_summary("", argv[1]);
    
    return (EXIT_SUCCESS);
}
#endif
