#!/bin/bash
#=================================================
# File name: hook-feeds.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Svn checkout packages from immortalwrt's repository

#5G信号插件，拨号工具，驱动
# rm -rf package/wwan
# git clone --depth=1 https://github.com/Siriling/5G-Modem-Support package/wwan

# Add iStoreOS
# echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
# echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
# echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

pushd customfeeds

# Add luci-proto-modemmanager
svn co https://github.com/immortalwrt/luci/trunk/protocols/luci-proto-modemmanager luci/protocols/luci-proto-modemmanager

# Set to local feeds
pushd customfeeds/packages
export packages_feed="$(pwd)"
popd
pushd customfeeds/luci
export luci_feed="$(pwd)"
popd
sed -i '/src-git packages/d' feeds.conf.default
echo "src-link packages $packages_feed" >> feeds.conf.default
sed -i '/src-git luci/d' feeds.conf.default
echo "src-link luci $luci_feed" >> feeds.conf.default

# Update feeds
./scripts/feeds update -a
