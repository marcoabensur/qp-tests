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
PROJECT     := sumo_hsm

OUTPUT    := $(PROJECT)

# C source files plataform-independent
C_SRCS := $(sort $(shell find ./src -name "*.c" -not -path "./src/target*"))

# List of all include directories needed by this project plataform-independent
C_HEADERS  = $(sort $(shell find ./inc -name "*.h" -not -path "./inc/target*"))

INCLUDES  := $(addprefix -I, $(sort $(dir $(C_HEADERS))))
INCLUDES += -I$(QPC)/include

# C++ source files
CPP_SRCS :=

QP_SRCS := \
	$(QPC)/src/qf/qep_hsm.c \
	$(QPC)/src/qf/qep_msm.c \
	$(QPC)/src/qf/qf_act.c \
	$(QPC)/src/qf/qf_actq.c \
	$(QPC)/src/qf/qf_defer.c \
	$(QPC)/src/qf/qf_dyn.c \
	$(QPC)/src/qf/qf_mem.c \
	$(QPC)/src/qf/qf_ps.c \
	$(QPC)/src/qf/qf_qact.c \
	$(QPC)/src/qf/qf_qeq.c \
	$(QPC)/src/qf/qf_qmact.c \
	$(QPC)/src/qf/qf_time.c \

ifeq (spy, $(CONF)) # SPY configuration ..................................


# For POSIX hosts (Linux, MacOS), you can choose:
# - the single-threaded QP/C port (win32-qv) or
# - the multithreaded QP/C port (win32).
#
QP_PORT_DIR := $(QPC)/ports/posix-qv
#QP_PORT_DIR := $(QPC)/ports/posix


C_HEADERS_TARGET  = $(sort $(shell find ./inc/target-pc -name "*.h"))

INCLUDES  += $(addprefix -I, $(sort $(dir $(C_HEADERS_TARGET))))
INCLUDES  += -I$(QP_PORT_DIR) 

QS_SRCS := \
	$(QPC)/src/qs/qs.c \
	$(QPC)/src/qs/qs_rx.c \
	$(QPC)/src/qs/qs_fp.c \
	$(QPC)/src/qs/qs_64bit.c \
	$(QP_PORT_DIR)/qs_port.c

C_SRCS += $(sort $(shell find ./src/target-pc -name "*.c"))
C_SRCS += $(QS_SRCS)

LD_SCRIPT :=

QP_SRCS += \
	$(QP_PORT_DIR)/qf_port.c

else # uC configuration ..................................

QP_PORT_DIR := $(QPC)/ports/arm-cm/qk/gnu

# list of all source directories used by this project

C_HEADERS_TARGET  = $(sort $(shell find ./inc/target-stm32f103 -name "*.h"))	
C_HEADERS_TARGET  += $(sort $(shell find ./cube -name "*.h"))	

INCLUDES  += $(addprefix -I, $(sort $(dir $(C_HEADERS_TARGET))))
INCLUDES  += -I$(QP_PORT_DIR) 

# assembler source files
ASM_SRCS := $(shell find ./cube/ -name "*.s")

C_SRCS += $(sort $(shell find ./src/target-stm32f103 -name "*.c"))
C_SRCS += $(sort $(shell find ./cube -name "*.c"))

LD_SCRIPT := cube/STM32F103RFTx_FLASH.ld

QP_SRCS += \
	$(QPC)/src/qk/qk.c \
	$(QP_PORT_DIR)/qk_port.c

endif


QP_ASMS :=

LIB_DIRS  :=
LIBS      :=

DEVICE_FAMILY  := STM32F1xx
DEVICE_TYPE    := STM32F103xx
DEVICE_DEF     := STM32F103xG
DEVICE         := STM32F103RF

# defines
DEFINES   := \
	-DQP_API_VERSION=9999

ifeq (spy, $(CONF)) # SPY configuration ..................................

CC    := gcc
CPP   := g++
AS    := as
LINK  := gcc    # for C programs
BIN   := objcopy
SIZE    := size
GDB     := gdb
HEX     := $(BIN) -O ihex

else # uC configuration ..................................

# ARM CPU, ARCH, FPU, and Float-ABI types...
# ARM_CPU:   [cortex-m0 | cortex-m0plus | cortex-m1 | cortex-m3 | cortex-m4]
# ARM_FPU:   [ | vfp]
# FLOAT_ABI: [ | soft | softfp | hard]
#
ARM_CPU   := -mcpu=cortex-m3
ARM_FPU   :=
FLOAT_ABI :=


CC    := $(ARM_GCC_PATH)/arm-none-eabi-gcc
CPP   := $(ARM_GCC_PATH)/arm-none-eabi-g++
AS    := $(ARM_GCC_PATH)/arm-none-eabi-as
LINK  := $(ARM_GCC_PATH)/arm-none-eabi-g++
BIN   := $(ARM_GCC_PATH)/arm-none-eabi-objcopy
SIZE    := $(ARM_GCC_PATH)/arm-none-eabi-size
GDB     := ${ARM_GCC_PATH}/arm-none-eabi-gdb
HEX     := $(BIN) -O ihex

endif

STM_PROG := $(CUBE_PROGRAMMER_PATH)/STM32_Programmer_CLI


##############################################################################

MKDIR := mkdir
RM    := rm

#-----------------------------------------------------------------------------
# build options for various configurations for ARM Cortex-M
#

# combine all the soruces...
C_SRCS += $(QP_SRCS)
ASM_SRCS += $(QP_ASMS)

# Specify Search directories
VPATH = $(sort $(dir $(C_SRCS)))
VPATH += $(sort $(dir $(ASM_SRCS)))

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

BIN_DIR := build_spy

DEFINES += -DQ_SPY

CFLAGS = -c -g -O -fno-pie -std=c11 -pedantic -Wall -Wextra -W -Wno-unused-result \
	$(INCLUDES) $(DEFINES) -Wno-unused-result

CPPFLAGS = -c -g -O -fno-pie -std=c++11 -pedantic -Wall -Wextra \
	-fno-rtti -fno-exceptions \
	$(INCLUDES) $(DEFINES)

ASFLAGS :=
LINKFLAGS := -no-pie
LIBS += -lpthread -lm

else # default Debug configuration ..........................................

BIN_DIR := build

DEFINES += -D$(DEVICE_DEF) \
	-DUSE_HAL_DRIVER

ASFLAGS = -g $(ARM_CPU) $(ARM_FPU) $(ASM_CPU) $(ASM_FPU)

CFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections \
	-O2 $(INCLUDES) $(DEFINES)

CPPFLAGS = -c -g $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb -Wall \
	-ffunction-sections -fdata-sections -fno-rtti -fno-exceptions \
	-O2 $(INCLUDES) $(DEFINES)

LINKFLAGS = -T$(LD_SCRIPT) $(ARM_CPU) $(ARM_FPU) $(FLOAT_ABI) -mthumb \
	-specs=nosys.specs -specs=nano.specs \
	-Wl,-Map,$(BIN_DIR)/$(OUTPUT).map,--cref,--gc-sections $(LIB_DIRS)

endif # ......................................................................



ASM_OBJS     := $(patsubst %.s,%.o,  $(notdir $(ASM_SRCS)))
C_OBJS       := $(patsubst %.c,%.o,  $(notdir $(C_SRCS)))
CPP_OBJS     := $(patsubst %.cpp,%.o,$(notdir $(CPP_SRCS)))

TARGET_BIN   := $(BIN_DIR)/$(OUTPUT).bin
TARGET_ELF   := $(BIN_DIR)/$(OUTPUT).elf
TARGET_HEX   := $(BIN_DIR)/$(OUTPUT).hex

ifeq (spy, $(CONF)) # SPY configuration ..................................
TARGET_EXE   := $(BIN_DIR)/$(OUTPUT)
endif

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

all: $(TARGET_BIN) $(TARGET_HEX) $(TARGET_EXE)
#all: $(TARGET_ELF)

$(TARGET_HEX): $(TARGET_ELF)
	@echo "Creating $@"
	$(HEX) $< $@

$(TARGET_BIN): $(TARGET_ELF)
	@echo "Creating $@"
	$(BIN) -O binary $< $@

$(TARGET_EXE) : $(C_OBJS_EXT) $(CPP_OBJS_EXT)
	@echo "Creating $@"
	$(CC) $(CFLAGS) $(QPC)/include/qstamp.c -o $(BIN_DIR)/qstamp.o
	$(LINK) $(LINKFLAGS) $(LIB_DIRS) -o $@ $^ $(BIN_DIR)/qstamp.o $(LIBS)

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

$(BIN_DIR)/%.o : %.s Makefile
	@echo "AS $<"
	$(AS) $(ASFLAGS) $< -o $@

$(BIN_DIR)/%.o : %.c Makefile
	@echo "CC $<"
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR)/%.o : %.cpp Makefile
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
	$(BIN_DIR)/*.map \
	$(BIN_DIR)/*.hex \
	$(TARGET_EXE)


show:
	@echo PROJECT = $(PROJECT)
	@echo ""
	@echo CONF = $(CONF)
	@echo ""
	@echo DEFINES = $(DEFINES)
	@echo ""
	@echo ASM_FPU = $(ASM_FPU)
	@echo ""
	@echo ASM_SRCS = $(ASM_SRCS)
	@echo ""
	@echo C_SRCS = $(C_SRCS)
	@echo ""
	@echo CPP_SRCS = $(CPP_SRCS)
	@echo ""
	@echo ASM_OBJS_EXT = $(ASM_OBJS_EXT)
	@echo ""
	@echo C_OBJS_EXT = $(C_OBJS_EXT)
	@echo ""
	@echo C_DEPS_EXT = $(C_DEPS_EXT)
	@echo ""
	@echo CPP_DEPS_EXT = $(CPP_DEPS_EXT)
	@echo ""
	@echo TARGET_ELF = $(TARGET_ELF)
	@echo ""
	@echo INCLUDES = $(INCLUDES)
	@echo ""
	@echo VPATH = $(VPATH)


prepare:
	@echo "Preparing cube files"
	$(AT)-mv -f cube/Src/main.c cube/Src/cube_main.c
	$(AT)-rm -f cube/Makefile

###############################################################################
## VS Code files
###############################################################################

VSCODE_FOLDER            := .vscode
VS_LAUNCH_FILE           := $(VSCODE_FOLDER)/launch.json
VS_C_CPP_PROPERTIES_FILE := $(VSCODE_FOLDER)/c_cpp_properties.json

NULL  :=
SPACE := $(NULL) #
COMMA := ,


ifeq (spy, $(CONF)) # SPY configuration ..................................
INTELLI_SENSE_MODE := linux-gcc-x64
COMPILER_PATH := /usr/bin/$(CC)
else
INTELLI_SENSE_MODE := linux-gcc-arm
COMPILER_PATH := $(CC)
endif



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
	        "name": "CONFIG",
	        "includePath": [
	            $(subst -I,$(NULL),$(subst $(SPACE),$(COMMA),$(strip $(foreach inc,$(INCLUDES),"$(inc)"))))
	        ],

	        "defines": [
	            $(subst -D,$(NULL),$(subst $(SPACE),$(COMMA),$(strip $(foreach def,$(DEFINES),"$(def)"))))
	        ],

	        "compilerPath": "$(COMPILER_PATH)",
	        "cStandard": "c99",
	        "cppStandard": "c++14",
	        "intelliSenseMode": "$(INTELLI_SENSE_MODE)"
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
