PROJECT_DEFS := RADIO_MODE_UART_CRSF
# PROJECT_DEFS := RADIO_MODE_UART



# STM32 CONFIGS
DEVICE_FAMILY  := STM32F1xx
DEVICE_TYPE    := STM32F103xx
DEVICE_DEF     := STM32F103xG
DEVICE         := STM32F103RF

ARM_CPU   := -mcpu=cortex-m3
ARM_FPU   :=
FLOAT_ABI :=


CUBE_LOCATION := cube/STM32F103RFT6
LINKER_FILE := $(CUBE_LOCATION)/STM32F103RFTx_FLASH.ld