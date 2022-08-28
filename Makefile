##############################################################################
# Product: Makefile for QP/C on NUCLEO-L053R8, QK kernel, GNU-ARM
# Last Updated for Version: 7.0.1
# Date of the Last Update:  2022-05-23
#
#                    Q u a n t u m  L e a P s
#                    ------------------------
#                    Modern Embedded Software
#
# Copyright (C) 2005-2021 Quantum Leaps, LLC. All rights reserved.
#
# This program is open source software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Alternatively, this program may be distributed and modified under the
# terms of Quantum Leaps commercial licenses, which expressly supersede
# the GNU General Public License and are specifically designed for
# licensees interested in retaining the proprietary status of their code.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses>.
#
# Contact information:
# <www.state-machine.com/licensing>
# <info@state-machine.com>
##############################################################################
# examples of invoking this Makefile:
# building configurations: Debug (default), Release, and Spy
# make
# make CONF=rel
# make CONF=spy
#
# cleaning configurations: Debug (default), Release, and Spy
# make clean
# make CONF=rel clean
# make CONF=spy clean
#
# NOTE:
# To use this Makefile on Windows, you will need the GNU make utility, which
# is included in the Qtools collection for Windows, see:
#    https://sourceforge.net/projects/qpc/files/QTools/
#

#-----------------------------------------------------------------------------
# project name
#
PROJECT     := blinky

#-----------------------------------------------------------------------------
# project directories
#

# location of the QP/C framework (if not provided in an environemnt var.)
ifeq ($(QPC),)
QPC := ../../../../..
endif

# QP port used in this project
QP_PORT_DIR := $(QPC)/ports/arm-cm/qk/gnu


# list of all source directories used by this project
VPATH = \
	. \
	$(QPC)/src/qf \
	$(QPC)/src/qs \
	$(QPC)/src/qk \
	$(QP_PORT_DIR) \
	cube/Drivers/STM32G4xx_HAL_Driver/Src \
	cube/ \
	cube/Src 

# list of all include directories needed by this project
INCLUDES  = \
	-I. \
	-I$(QPC)/include \
	-I$(QP_PORT_DIR) \
	-Icube/Drivers/CMSIS/Device/ST/STM32G4xx/Include \
	-Icube/Drivers/CMSIS/Include \
	-Icube/Drivers/STM32G4xx_HAL_Driver/Inc \
	-Icube/Inc

#-----------------------------------------------------------------------------
# files
#

# assembler source files
ASM_SRCS := cube/startup_stm32g431xx.s

# C source files
C_SRCS := \
	blinky.c \
	bsp.c \
	main.c \
	cube/Src/stm32g4xx_hal_msp.c \
	cube/Src/system_stm32g4xx.c \
	cube/Src/usart.c \
	cube/Src/stm32g4xx_it.c \
	cube/Src/cube_main.c \
	cube/Src/gpio.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_cortex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rcc.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_exti.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_tim_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_rcc_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_flash_ramfunc.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_uart_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_uart.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_pwr_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_tim.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_dma_ex.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_pwr.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_dma.c \
	cube/Drivers/STM32G4xx_HAL_Driver/Src/stm32g4xx_hal_gpio.c 

# C++ source files
CPP_SRCS :=

OUTPUT    := $(PROJECT)
LD_SCRIPT := cube/STM32G431KBTx_FLASH.ld

QP_SRCS := \
	qep_hsm.c \
	qep_msm.c \
	qf_act.c \
	qf_actq.c \
	qf_defer.c \
	qf_dyn.c \
	qf_mem.c \
	qf_ps.c \
	qf_qact.c \
	qf_qeq.c \
	qf_qmact.c \
	qf_time.c \
	qk.c \
	qk_port.c

QP_ASMS :=

QS_SRCS := \
	qs.c \
	qs_rx.c \
	qs_fp.c

LIB_DIRS  :=
LIBS      :=


DEVICE_FAMILY  := STM32G4xx
DEVICE_TYPE    := STM32G431xx
DEVICE_DEF     := STM32G431xx
DEVICE         := STM32G431KB

# defines
DEFINES   := \
	-DQP_API_VERSION=9999 \
	-D$(DEVICE_TYPE) \
	-DUSE_HAL_DRIVER

# ARM CPU, ARCH, FPU, and Float-ABI types...
# ARM_CPU:   [cortex-m0 | cortex-m0plus | cortex-m1 | cortex-m3 | cortex-m4]
# ARM_FPU:   [ | vfp]
# FLOAT_ABI: [ | soft | softfp | hard]
#
ARM_CPU   := -mcpu=cortex-m4
ARM_FPU   :=
FLOAT_ABI :=

#-----------------------------------------------------------------------------
# GNU-ARM toolset (NOTE: You need to adjust to your machine)
# see https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads
#
ifeq ($(ARM_GCC_PATH),)
ARM_GCC_PATH := $(QTOOLS)/ARM_GCC_PATH-none-eabi
endif

# make sure that the GNU-ARM toolset exists...
ifeq ("$(wildcard $(ARM_GCC_PATH))","")
$(error ARM_GCC_PATH toolset not found. Please adjust the Makefile)
endif

CC    := $(ARM_GCC_PATH)/arm-none-eabi-gcc
CPP   := $(ARM_GCC_PATH)/arm-none-eabi-g++
AS    := $(ARM_GCC_PATH)/arm-none-eabi-as
LINK  := $(ARM_GCC_PATH)/arm-none-eabi-g++
BIN   := $(ARM_GCC_PATH)/arm-none-eabi-objcopy
SIZE    := $(ARM_GCC_PATH)/arm-none-eabi-size
GDB     := ${ARM_GCC_PATH}/arm-none-eabi-gdb
HEX     := $(BIN) -O ihex

STM_PROG := /home/marco/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI


##############################################################################
# Typically, you should not need to change anything below this line

# basic utilities (included in Qtools for Windows), see:
#    http://sourceforge.net/projects/qpc/files/Qtools

MKDIR := mkdir
RM    := rm

#-----------------------------------------------------------------------------
# build options for various configurations for ARM Cortex-M
#

# combine all the soruces...
C_SRCS += $(QP_SRCS)
ASM_SRCS += $(QP_ASMS)

ifeq (rel, $(CONF)) # Release configuration ..................................

BIN_DIR := rel

ASFLAGS = $(ARM_CPU) $(ARM_FPU) $(ASM_CPU) $(ASM_FPU)

CFLAGS = -c $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections \
	-O2 $(INCLUDES) $(DEFINES) -DNDEBUG

CPPFLAGS = -c $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections -fno-rtti -fno-exceptions \
	-O2 $(INCLUDES) $(DEFINES) -DNDEBUG

else ifeq (spy, $(CONF))  # Spy configuration ................................

BIN_DIR := spy

C_SRCS += $(QS_SRCS)

ASFLAGS = -g $(ARM_CPU) $(ARM_FPU) $(ASM_CPU) $(ASM_FPU)

CFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections \
	-O2 $(INCLUDES) $(DEFINES) -DQ_SPY

CPPFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections -fno-rtti -fno-exceptions \
	-O2 $(INCLUDES) $(DEFINES) -DQ_SPY

else # default Debug configuration ..........................................

BIN_DIR := dbg

ASFLAGS = -g $(ARM_CPU) $(ARM_FPU) $(ASM_CPU) $(ASM_FPU)

CFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections \
	-O2 $(INCLUDES) $(DEFINES)

CPPFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections -fno-rtti -fno-exceptions \
	-O2 $(INCLUDES) $(DEFINES)

endif # ......................................................................


LINKFLAGS = -T$(LD_SCRIPT) $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb \
	-specs=nosys.specs -specs=nano.specs \
	-Wl,-Map,$(BIN_DIR)/$(OUTPUT).map,--cref,--gc-sections $(LIB_DIRS)


ASM_OBJS     := $(patsubst %.s,%.o,  $(notdir $(ASM_SRCS)))
C_OBJS       := $(patsubst %.c,%.o,  $(notdir $(C_SRCS)))
CPP_OBJS     := $(patsubst %.cpp,%.o,$(notdir $(CPP_SRCS)))

TARGET_BIN   := $(BIN_DIR)/$(OUTPUT).bin
TARGET_ELF   := $(BIN_DIR)/$(OUTPUT).elf
TARGET_HEX   := $(BIN_DIR)/$(OUTPUT).hex

ASM_OBJS_EXT := $(addprefix $(BIN_DIR)/, $(ASM_OBJS))
C_OBJS_EXT   := $(addprefix $(BIN_DIR)/, $(C_OBJS))
C_DEPS_EXT   := $(patsubst %.o, %.d, $(C_OBJS_EXT))
CPP_OBJS_EXT := $(addprefix $(BIN_DIR)/, $(CPP_OBJS))
CPP_DEPS_EXT := $(patsubst %.o, %.d, $(CPP_OBJS_EXT))

# create $(BIN_DIR) if it does not exist
ifeq ("$(wildcard $(BIN_DIR))","")
$(shell $(MKDIR) $(BIN_DIR))
endif

#-----------------------------------------------------------------------------
# rules
#

all: $(TARGET_BIN) $(TARGET_HEX)
#all: $(TARGET_ELF)

$(TARGET_HEX): $(TARGET_ELF)
	@echo "Creating $@"
	$(HEX) $< $@

$(TARGET_BIN): $(TARGET_ELF)
	@echo "Creating $@"
	$(BIN) -O binary $< $@

$(TARGET_ELF) : $(ASM_OBJS_EXT) $(C_OBJS_EXT) $(CPP_OBJS_EXT)
	@echo "CC $@"
	$(CC) $(CFLAGS) $(QPC)/include/qstamp.c -o $(BIN_DIR)/qstamp.o
	$(LINK) $(LINKFLAGS) -o $@ $^ $(BIN_DIR)/qstamp.o $(LIBS)
	$(AT)$(SIZE) $@

$(BIN_DIR)/%.d : %.c
	@echo "DCC $<"
	$(CC) -MM -MT $(@:.d=.o) $(CFLAGS) $< > $@

$(BIN_DIR)/%.d : %.cpp
	@echo "DPP $<"
	$(CPP) -MM -MT $(@:.d=.o) $(CPPFLAGS) $< > $@

$(BIN_DIR)/%.o : %.s
	@echo "AS $<"
	$(AS) $(ASFLAGS) $< -o $@

$(BIN_DIR)/%.o : %.c
	@echo "CC $<"
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR)/%.o : %.cpp
	@echo "CPP $<"
	$(CPP) $(CPPFLAGS) $< -o $@

# include dependency files only if our goal depends on their existence
ifneq ($(MAKECMDGOALS),clean)
  ifneq ($(MAKECMDGOALS),show)
-include $(C_DEPS_EXT) $(CPP_DEPS_EXT)
  endif
endif

# Flash Built files with STM32CubeProgrammer
flash load:
	@echo "Flashing $(TARGET_HEX) with STM32_Programmer_CLI"
	$(AT)$(STM_PROG) -c port=SWD -w $(TARGET_HEX) -v -rst


.PHONY : clean
clean:
	-$(RM) $(BIN_DIR)/*.o \
	$(BIN_DIR)/*.d \
	$(BIN_DIR)/*.bin \
	$(BIN_DIR)/*.elf \
	$(BIN_DIR)/*.map
	
show:
	@echo PROJECT = $(PROJECT)
	@echo CONF = $(CONF)
	@echo DEFINES = $(DEFINES)
	@echo ASM_FPU = $(ASM_FPU)
	@echo ASM_SRCS = $(ASM_SRCS)
	@echo C_SRCS = $(C_SRCS)
	@echo CPP_SRCS = $(CPP_SRCS)
	@echo ASM_OBJS_EXT = $(ASM_OBJS_EXT)
	@echo C_OBJS_EXT = $(C_OBJS_EXT)
	@echo C_DEPS_EXT = $(C_DEPS_EXT)
	@echo CPP_DEPS_EXT = $(CPP_DEPS_EXT)
	@echo TARGET_ELF = $(TARGET_ELF)

###############################################################################
## VS Code files
###############################################################################

VSCODE_FOLDER            := .vscode
VS_LAUNCH_FILE           := $(VSCODE_FOLDER)/launch.json
VS_C_CPP_PROPERTIES_FILE := $(VSCODE_FOLDER)/c_cpp_properties.json

NULL  :=
SPACE := $(NULL) #
COMMA := ,

define VS_LAUNCH
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "cortex-debug",
            "request": "launch",
            "servertype": "stutil",
            "cwd": "$${workspaceRoot}",
            "gdbPath": "${GDB}",
            "executable": "$(TARGET_ELF)",
            "name": "Cortex Debug (ST-Util)",
            "device": "$(DEVICE)",
            "v1": false
        },
        {
            "type": "cortex-debug",
            "request": "launch",
            "servertype": "jlink",
            "cwd": "$${workspaceRoot}",
            "gdbPath": "${GDB}",
            "executable": "$(TARGET_ELF)",
            "name": "Cortex Debug (J-Link)",
            "device": "$(DEVICE)",
            "interface": "swd",
        }
    ]
}
endef

define VS_CPP_PROPERTIES
{
    "configurations": [
        {
            "name": "STM32_TR",
            "includePath": [
                $(subst -I,$(NULL),$(subst $(SPACE),$(COMMA),$(strip $(foreach inc,$(INCLUDES),"$(inc)"))))
            ],

            "defines": [
                $(subst -D,$(NULL),$(subst $(SPACE),$(COMMA),$(strip $(foreach def,$(DEFINES),"$(def)"))))
            ],

            "compilerPath": "${CC}",
            "cStandard": "c99",
            "cppStandard": "c++14",
            "intelliSenseMode": "linux-gcc-arm"
        }
    ],
    "version": 4
}
endef

export VS_LAUNCH
export VS_CPP_PROPERTIES

vs_files: $(VS_LAUNCH_FILE) $(VS_C_CPP_PROPERTIES_FILE)

$(VS_LAUNCH_FILE): config.mk Makefile | $(VSCODE_FOLDER)
	$(AT)echo "$$VS_LAUNCH" > $@

$(VS_C_CPP_PROPERTIES_FILE): config.mk Makefile | $(VSCODE_FOLDER)
	$(AT)echo "$$VS_CPP_PROPERTIES" > $@

$(VSCODE_FOLDER):
	$(AT)mkdir -p $@
