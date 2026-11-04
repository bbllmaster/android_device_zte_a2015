#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_l_mr1.mk)

# Inherit from the device configuration.
$(call inherit-product, device/zte/a2015/device.mk)

# Wi-Fi-only: no telephony packages.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

PRODUCT_NAME := lineage_a2015
PRODUCT_DEVICE := a2015
PRODUCT_MANUFACTURER := ZTE
PRODUCT_BRAND := ZTE
PRODUCT_MODEL := ZTE A2015

PRODUCT_GMS_CLIENTID_BASE := android-zte

TARGET_VENDOR := zte
