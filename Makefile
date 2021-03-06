KERNEL_SRC ?= ../kernel

KBUILD_OPTIONS := WLAN_ROOT=$(PWD)
KBUILD_OPTIONS += MODNAME?=wlan

# Determine if the driver license is Open source or proprietary
# This is determined under the assumption that LICENSE doesn't change.
# Please change here if driver license text changes.
LICENSE_FILE ?= $(PWD)/$(WLAN_ROOT)/CORE/HDD/src/wlan_hdd_main.c
WLAN_OPEN_SOURCE = $(shell if grep -q "MODULE_LICENSE(\"Dual BSD/GPL\")" \
		$(LICENSE_FILE); then echo 1; else echo 0; fi)

#By default build for CLD
WLAN_SELECT := CONFIG_QCA_CLD_WLAN=m
KBUILD_OPTIONS += CONFIG_QCA_WIFI_ISOC=0
KBUILD_OPTIONS += CONFIG_QCA_WIFI_2_0=1
KBUILD_OPTIONS += $(WLAN_SELECT)
KBUILD_OPTIONS += WLAN_OPEN_SOURCE=$(WLAN_OPEN_SOURCE)
#KBUILD_OPTIONS += $(KBUILD_EXTRA) # Extra config if any
KBUILD_OPTIONS += CONFIG_QCACLD_WLAN_LFR3=y
KBUILD_OPTIONS += CONFIG_PRIMA_WLAN_OKC=y
KBUILD_OPTIONS += CONFIG_PRIMA_WLAN_11AC_HIGH_TP=y
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_11W=y
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_LPSS=y
KBUILD_OPTIONS += CONFIG_QCOM_VOWIFI_11R=y
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_NAN=y
KBUILD_OPTIONS += CONFIG_QCOM_TDLS=y
KBUILD_OPTIONS += CONFIG_QCOM_LTE_COEX=y
KBUILD_OPTIONS += CONFIG_WLAN_FEATURE_MEMDUMP=y
KBUILD_OPTIONS += CONFIG_WLAN_OFFLOAD_PACKETS=y
KBUILD_OPTIONS += CONFIG_QCA_WIFI_AUTOMOTIVE_CONC=y
KBUILD_OPTIONS += CONFIG_WLAN_UDP_RESPONSE_OFFLOAD=y

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(shell pwd) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(PWD) clean
