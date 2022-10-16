#include <stdio.h>  
#include <stdbool.h>

#include "qpc.h"  
#include "bsp.h"
#include "bsp_led.h"

#ifdef Q_SPY
#include "qs_defines.h"
#endif

void BSP_ledInit(void) {
    printf("LED INIT\n"); 
}


void BSP_ledOff(void) { 
    printf("LED OFF\n"); 
    QS_BEGIN_ID(SIMULATOR, AO_SumoHSM->prio)
       QS_I8(1, QS_LED_ID);
       QS_I8(1, 0);
    QS_END()
}



void BSP_ledOn(void)  { 
    printf("LED ON\n");  
    QS_BEGIN_ID(SIMULATOR, AO_SumoHSM->prio)
       QS_I8(1, QS_LED_ID);
       QS_I8(1, 1);
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


void BSP_ledStripe(uint8_t num, uint8_t r, uint8_t g, uint8_t b) {

    printf("Led Strip Num %d RGB = %x,%x,%x\n", num, r, g, b); 

    QS_BEGIN_ID(SIMULATOR, AO_SumoHSM->prio);
       QS_U8(1, QS_LED_STRIPE_ID);
       QS_U8(1, num);
       QS_U8(1, r);
       QS_U8(1, g);
       QS_U8(1, b);
    QS_END()

}

void BSP_ledStripeSetAll(uint8_t r, uint8_t g, uint8_t b){
    printf("BSP_ledStripeSetAll RGB = %x,%x,%x\n", r, g, b); 
    
    QS_BEGIN_ID(SIMULATOR, AO_SumoHSM->prio);
       QS_U8(1, QS_LED_STRIPE_ID);
       QS_U8(1, 255);
       QS_U8(1, r);
       QS_U8(1, g);
       QS_U8(1, b);
    QS_END();
}

void BSP_ledStripeSetHalf(bool left_half, uint8_t r, uint8_t g, uint8_t b){
    printf("BSP_ledStripeSetHalf RGB = %x,%x,%x. Left = %d\n", r, g, b, left_half); 

    uint8_t code = left_half ? 254 : 253;
    
    QS_BEGIN_ID(SIMULATOR, AO_SumoHSM->prio);
       QS_U8(1, QS_LED_STRIPE_ID);
       QS_U8(1, code);
       QS_U8(1, r);
       QS_U8(1, g);
       QS_U8(1, b);
    QS_END();
}


void BSP_ledStripeSetStrategyColor(uint8_t strategy_num){
    uint8_t r, g, b;

    switch (strategy_num) {
        case 0:
            r = 0xff;
            g = 0x00;
            b = 0x00;
            break;
        case 1:
            r = 0x00;
            g = 0xff;
            b = 0x00;
            break;
        case 2:
            r = 0x00;
            g = 0x00;
            b = 0xff;
            break;
        
        default:
            r = 0x00;
            g = 0x00;
            b = 0x00;
            break;
    }

    BSP_ledStripeSetHalf(true, r, g, b);
    
}

void BSP_ledStripeSetPreStrategyColor(uint8_t pre_strategy_num){
    uint8_t r, g, b;

    switch (pre_strategy_num) {
        case 0:
            r = 0xff;
            g = 0x00;
            b = 0x00;
            break;
        case 1:
            r = 0x00;
            g = 0xff;
            b = 0x00;
            break;
        case 2:
            r = 0x00;
            g = 0x00;
            b = 0xff;
            break;
        
        case 3:
            r = 0x00;
            g = 0xff;
            b = 0xff;
            break;

        default:
            r = 0x00;
            g = 0x00;
            b = 0x00;
            break;
    }

    BSP_ledStripeSetHalf(false, r, g, b);


    
}