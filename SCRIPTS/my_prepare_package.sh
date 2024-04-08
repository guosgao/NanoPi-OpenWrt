#!/bin/bash

OP_SC_DIR=$(pwd)


################ 修改 Nick 的脚本 -Start- ################
# 创建插件存放目录
mkdir -p package/new

# 移除多余组件
sed -i '/# AutoReboot/,/# Golang/d' 02_prepare_package.sh
sed -i '/# Ram-free/,/fuck/d' 02_prepare_package.sh
################ 修改 Nick 的脚本 -End- ################


################ 执行 02 脚本 -Start- ################
/bin/bash 02_prepare_package.sh
################ 执行 02 脚本 -End- ################


################ 自定义部分 -Start- ################
# 调整 LuCI 依，替换主题 bootstrap 为 argo
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' ./feeds/luci/collections/luci-light/Makefile

# Argon 主题
bash ${OP_SC_DIR}/../PATCH/app/Argon.sh

# ShellClash
bash ${OP_SC_DIR}/../PATCH/app/ShellClash.sh

#增加风扇调速（被动散热不香么？
wget -P target/linux/rockchip/armv8/base-files/etc/init.d/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/etc/init.d/fa-rk3328-pwmfan
wget -P target/linux/rockchip/armv8/base-files/usr/bin/ https://github.com/friendlyarm/friendlywrt/raw/master-v19.07.1/target/linux/rockchip-rk3328/base-files/usr/bin/start-rk3328-pwm-fan.sh

# frpc
# bash ${OP_SC_DIR}/../PATCH/app/frpc.sh

# Wake-on-LAN-plus
# svn export https://github.com/msylgj/OpenWrt_luci-app/trunk/luci-app-services-wolplus package/new/luci-app-services-wolplus

# Docker
# pushd feeds/packages
#   wget -qO- https://github.com/openwrt/packages/commit/d9d5109.patch | patch -p1
# popd
# sed -i '/sysctl.d/d' feeds/packages/utils/dockerd/Makefile

# 调整默认 LAN IP
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate
################ 自定义部分 -End- ################


unset OP_SC_DIR

exit 0
