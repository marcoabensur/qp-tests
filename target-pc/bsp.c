/*$file${.::bsp.c} vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv*/
/*
* Model: blinky_console.qm
* File:  ${.::bsp.c}
*
* This code has been generated by QM 5.2.1 <www.state-machine.com/qm>.
* DO NOT EDIT THIS FILE MANUALLY. All your changes will be lost.
*
* SPDX-License-Identifier: GPL-3.0-or-later
*
* This generated code is open source software: you can redistribute it under
* the terms of the GNU General Public License as published by the Free
* Software Foundation.
*
* This code is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
*
* NOTE:
* Alternatively, this generated code may be distributed under the terms
* of Quantum Leaps commercial licenses, which expressly supersede the GNU
* General Public License and are specifically designed for licensees
* interested in retaining the proprietary status of their code.
*
* Contact information:
* <www.state-machine.com/licensing>
* <info@state-machine.com>
*/
/*$endhead${.::bsp.c} ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
/* Board Support Package implementation for desktop OS (Windows, Linux, MacOS) */
#include "qpc.h"    /* QP/C framework API */
#include "bsp.h"    /* Board Support Package interface */
#include <stdio.h>  /* for printf()/fprintf() */
#include <stdlib.h> /* for exit() */
#include <stdbool.h>

#ifdef Q_SPY

enum {
   LED = QS_USER
};

static QSpyId const l_clock_tick = { QS_AP_ID };

#endif

void BSP_init(void)   {
    printf("Simple Blinky example\n"
           "QP/C version: %s\n"
           "Press Ctrl-C to quit...\n",
           QP_VERSION_STR);

    #ifdef Q_SPY

    QS_INIT((void *)0);
        

    QS_FUN_DICTIONARY(&QHsm_top);
    QS_OBJ_DICTIONARY(&l_clock_tick);
    QS_USR_DICTIONARY(LED);

    /* setup the QS filters... */
    QS_GLB_FILTER(QS_ALL_RECORDS);
    QS_GLB_FILTER(-QS_QF_TICK);

    #endif


    
}
void BSP_ledOff(void) { 
    printf("LED OFF\n"); 
    QS_BEGIN_ID(LED, AO_Blinky->prio)
       QS_U8(1, 0);
    QS_END()
}



void BSP_ledOn(void)  { 
    printf("LED ON\n");  
    QS_BEGIN_ID(LED, AO_Blinky->prio)
       QS_U8(1, 1);
    QS_END()

}

void BSP_ledToggle(void)  {
    static bool toggle = false;
    if (toggle){
        BSP_ledOff();
    } else {
        BSP_ledOn();
    }
    toggle = !toggle;

}


/* callback functions needed by the framework ------------------------------*/
void QF_onStartup(void) {}
void QF_onCleanup(void) {}
void QF_onClockTick(void) {
    QF_TICK_X(0U, (void *)0); /* QF clock tick processing for rate 0 */

    #ifdef Q_SPY
    QS_RX_INPUT(); /* handle the QS-RX input */
    QS_OUTPUT();   /* handle the QS output */
    #endif

}
void Q_onAssert(char const * const module, int loc) {
    fprintf(stderr, "Assertion failed in %s:%d", module, loc);
    exit(-1);
}

#ifdef Q_SPY
/*..........................................................................*/
/*! callback function to execute user commands */
void QS_onCommand(uint8_t cmdId,
                  uint32_t param1, uint32_t param2, uint32_t param3)
{
    switch (cmdId) {
       case 0: { 
            QEvt evt;
            // evt.sig = START_RC_SIG;
            // QHsm_dispatch_(&AO_Blinky->super, &evt, 0);
            break;
        }
       default:
           break;
    }

    /* unused parameters */
    (void)param1;
    (void)param2;
    (void)param3;
}
#endif
