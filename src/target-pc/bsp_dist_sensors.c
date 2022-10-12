#include <stdio.h>  
#include <stdint.h>

#include "qpc.h"  
#include "bsp.h"
#include "bsp_dist_sensors.h"


#ifdef Q_SPY
#include "qs_defines.h"
#endif

bool dist_sensors[NUM_OF_DIST_SENSORS];

void BSP_distSensorsInit(void){
    printf("Dist Sensors init \r\n"); 
}

bool BSP_distSensorIsReading(dist_position_t sensor){

    if (sensor >= NUM_OF_DIST_SENSORS){
        return 0;
    }

    return dist_sensors[sensor];

}

void BSP_distSensorSet(dist_position_t sensor, bool value){

    if (sensor >= NUM_OF_DIST_SENSORS){
        return;
    }

    dist_sensors[sensor] = value;

}

void BSP_distSensorDisableAll(){

    for (uint8_t i = 0; i < NUM_OF_DIST_SENSORS; i++)
    {
        dist_sensors[i] = 0;
    }
    
}