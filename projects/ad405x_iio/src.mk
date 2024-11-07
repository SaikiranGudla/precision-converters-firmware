# All the .c and .cpp and .h Files in SRC_DIRS are used in Build (Recursive)
SRC_DIRS += $(PROJECT_APP_PATH)
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/drivers/adc/ad405x
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/drivers/eeprom/24xx32a
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/drivers/api
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/util
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/iio
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/include
SRC_DIRS += $(LIBRARIES_PATH)/precision-converters-library/common
SRC_DIRS += $(LIBRARIES_PATH)/precision-converters-library/board_info
SRC_DIRS += $(LIBRARIES_PATH)/precision-converters-library/sdp_k1_sdram

ifeq 'mbed' '$(PLATFORM)'
# ALL_IGNORED_FILES variable used for excluding particular source files in SRC_DIRS in Build
SRC_DIRS += $(LIBRARIES_PATH)/no-OS/drivers/platform/mbed
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/app_config_stm32.c
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/stm32_gpio_irq_generated.c
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/app_config_stm32.h

# Extra Macros
override NEW_CFLAGS += -DACTIVE_PLATFORM=MBED_PLATFORM
endif

# Add support for STM32 platform
ifeq 'stm32' '$(PLATFORM)'

# ALL_IGNORED_FILES variable used for excluding particular source files in SRC_DIRS in Build
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/stm32_tdm_support.c
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/stm32_gpio_irq_generated.c
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/app_config_mbed.h
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/app_config_mbed.c
ALL_IGNORED_FILES += $(PROJECT_APP_PATH)/stm32_tdm_support.h

ACTIVE_PLATFORM?=STM32_PLATFORM

# stm32 specific build directory tree (project goes under app, but user .c/.h sources must go under app/Core)
PROJECT_BUILDROOT = $(BUILD_DIR)/app
PROJECT_BUILD = $(PROJECT_BUILDROOT)/Core
RELEASE_DIR = $(PROJECT_BUILDROOT)/Release
DEBUG_DIR = $(PROJECT_BUILDROOT)/Debug
EXTI_GEN_FILE = $(NO-OS)/drivers/platform/stm32/stm32_gpio_irq_generated.c


# Add all .c files related to stm32 to PLATFORM_SRCS in full path
PLATFORM_SRCS += $(call rwildcard, $(PROJECT_BUILDROOT)/Drivers, *.c)
#SRCS += $(call rwildcard, $(PROJECT_BUILDROOT)/Drivers, *.c)
PLATFORM_SRCS += $(call rwildcard, $(PROJECT_BUILD)/Src, *.c)

# Add all relevant stm32 include directories with -I prefix
 EXTRA_INCS += $(call rwildcard, $(PROJECT_BUILDROOT)/Drivers, *.h)
#INCS += $(call rwildcard, $(PROJECT_BUILDROOT)/Drivers, *.h)
EXTRA_INCS += $(call rwildcard, $(PROJECT_BUILD)/Inc, *.h)
#INCS += $(call rwildcard, $(PROJECT_BUILD)/Inc, *.h)
PLATFORM_INCS += $(sort $(foreach h,$(EXTRA_INCS), -I$(dir $h)))

# Get the path of the hal config file
HALCONF = $(call rwildcard, $(PROJECT_BUILD)/Inc,*_hal_conf.h)

# Add the necessary STM32 includes
INCS += $(PLATFORM_DRIVERS)/stm32_delay.h     \
        $(PLATFORM_DRIVERS)/stm32_gpio.h      \
        $(PLATFORM_DRIVERS)/stm32_hal.h       \
        $(PLATFORM_DRIVERS)/stm32_spi.h       \
        $(PLATFORM_DRIVERS)/stm32_irq.h       \
        $(PLATFORM_DRIVERS)/stm32_gpio_irq.h  \
        $(PLATFORM_DRIVERS)/stm32_uart.h      \
        $(PLATFORM_DRIVERS)/stm32_uart_stdio.h \
        $(PLATFORM_DRIVERS)/stm32_dma.h		\
        $(PLATFORM_DRIVERS)/stm32_pwm.h		\
        $(PLATFORM_DRIVERS)/stm32_i2c.h

# Add the necessary STM32 sources
SRCS += $(PLATFORM_DRIVERS)/stm32_delay.c     \
        $(PLATFORM_DRIVERS)/stm32_gpio.c      \
        $(PLATFORM_DRIVERS)/stm32_spi.c       \
        $(PLATFORM_DRIVERS)/stm32_dma.c       \
        $(PLATFORM_DRIVERS)/stm32_irq.c       \
        $(PLATFORM_DRIVERS)/stm32_gpio_irq.c  \
        $(PLATFORM_DRIVERS)/stm32_uart.c      \
        $(PLATFORM_DRIVERS)/stm32_uart_stdio.c\
        $(PLATFORM_DRIVERS)/stm32_pwm.c	      \
        $(PLATFORM_DRIVERS)/stm32_i2c.c

# Extra Macros for compilation.
override NEW_CFLAGS += -DACTIVE_PLATFORM=STM32_PLATFORM -DUSE_PHY_COM_PORT
endif