#!/bin/bash
#=================================================
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
# Clone community packages to package/community

# 删除冲突插件
rm -rf customfeeds/luci/applications/luci-app-mosdns && rm -rf customfeeds/packages/net/{alist,adguardhome,smartdns}

# 添加第三方应用
mkdir Modem-Support
pushd Modem-Support
git clone --depth=1 https://github.com/Siriling/5G-Modem-Support .
popd

mkdir kenzok8-small
pushd kenzok8-small
git clone --depth=1 https://github.com/kenzok8/small-package .
rm -rf {base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd-alt,miniupnpd-iptables,wireless-regdb}
popd

mkdir MyConfig
pushd MyConfig
git clone --depth=1 https://github.com/Siriling/OpenWRT-MyConfig .
popd

# Add application
mkdir package/community
pushd package/community

# iStore应用
mkdir taskd
mkdir luci-lib-taskd
mkdir luci-lib-xterm
mkdir luci-app-store
mkdir quickstart
mkdir luci-app-quickstart
cp -rf ../../kenzok8-small/taskd/* taskd
cp -rf ../../kenzok8-small/luci-lib-taskd/* luci-lib-taskd
cp -rf ../../kenzok8-small/luci-lib-xterm/* luci-lib-xterm
cp -rf ../../kenzok8-small/luci-app-store/* luci-app-store
cp -rf ../../kenzok8-small/quickstart/* quickstart
cp -rf ../../kenzok8-small/luci-app-quickstart/* luci-app-quickstart

# 网络接口
#Minieap
mkdir luci-proto-minieap
cp -rf ../../kenzok8-small/luci-proto-minieap/* luci-proto-minieap
# cp -rf ../../kenzok8-small/luci-app-minieap/* luci-app-minieap

# 主题
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
rm -rf ../../customfeeds/luci/themes/luci-theme-argon
rm -rf ../../customfeeds/luci/themes/luci-theme-argon-mod
rm -rf ./luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/images/bg1.jpg luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg # 修改默认背景
git clone https://github.com/DHDAXCW/theme

# 5G通信模组拨号工具
rm -rf package/wwan/driver/quectel_QMI_WWAN
rm -rf package/wwan/driver/quectel_MHI
rm -rf package/wwan/app/quectel_cm_5G
mkdir quectel_QMI_WWAN
mkdir quectel_MHI
mkdir quectel_cm_5G
# mkdir luci-app-hypermodem
cp -rf ../../Modem-Support/quectel_QMI_WWAN/* quectel_QMI_WWAN
cp -rf ../../Modem-Support/quectel_MHI/* quectel_MHI
cp -rf ../../Modem-Support/quectel_cm_5G/* quectel_cm_5G
# cp -rf ../../Modem-Support/luci-app-hypermodem/* luci-app-hypermodem

# 5G模组短信插件
# rm -rf customfeeds/luci/applications/luci-app-sms-tool
# mkdir luci-app-sms-tool
# cp -rf ../../Modem-Support/luci-app-sms-tool/* luci-app-sms-tool
# cp -rf ../../MyConfig/configs/istoreos/general/applications/luci-app-sms-tool/* luci-app-sms-tool

#5G模组插件
rm -rf customfeeds/package/utils/sms-tool
mkdir sms-tool
mkdir luci-app-modem
cp -rf ../../Modem-Support/sms-tool/* sms-tool
cp -rf ../../Modem-Support/luci-app-modem/* luci-app-modem

popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
sed -i '/18.06/d' zzz-default-settings
export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
popd

# 5G模组拨号脚本
mkdir -p package/base-files/files/root/5GModem
cp -rf $GITHUB_WORKSPACE/tools/5G模组拨号脚本/5GModem/* package/base-files/files/root/5GModem
chmod -R a+x package/base-files/files/root/5GModem
svn export https://github.com/Siriling/OpenWRT-MyConfig/configs/lede/general/etc/crontabs package/base-files/files/etc/crontabs

# 修改默认IP地址
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 修改主机名字
sed -i 's/OpenWrt/FM10/g' package/base-files/files/bin/config_generate

# 给添加的代码添加汉化
sed -i '$a\\nmsgid "Compiler author"\nmsgstr "编译作者"' feeds/luci/modules/luci-base/po/zh-cn/base.po
sed -i '$a\\nmsgid "Resources link"\nmsgstr "资源链接"' feeds/luci/modules/luci-base/po/zh-cn/base.po

# 更默认命令行样式（shell to zsh）
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# 编译新版Sing-box和hysteria，需golang版本1.20或者以上版本
pushd customfeeds/packages/lang
rm -rf golang
git clone https://github.com/kenzok8/golang customfeeds/packages/lang/golang
popd
