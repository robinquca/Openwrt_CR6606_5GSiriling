#!/bin/bash
#=================================================
# File name: init-settings.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'

# Disable opkg signature check
# sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

# 禁用ipv6前缀
sed -i 's/^[^#].*option ula/#&/' /etc/config/network

if [ ! -f "/boot/init.sh" ]; then
bash /boot/init.sh
fi

exit 0
