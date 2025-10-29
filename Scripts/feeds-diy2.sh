#!/bin/bash

echo "删除官方插件..."
rm -rf ./feeds/luci/applications/luci-app-{passwall*,mosdns,dockerman,dae*,bypass*}
rm -rf ./feeds/packages/net/{v2ray-geodata,dae*}

echo "替换 watchcat..."
rm -rf ./feeds/packages/utils/watchcat
mv .feeds/GPackages/openwrt-watchcat-plus/watchcat ./feeds/packages/utils/watchcat

echo "更新 golang..."
rm -rf ./feeds/packages/lang/golang
git clone -b 25.x https://github.com/sbwml/packages_lang_golang ./feeds/packages/lang/golang

echo "修复 coremark..."
sed -i 's/mkdir \$(PKG_BUILD_DIR)\/\$(ARCH)/mkdir -p \$(PKG_BUILD_DIR)\/\$(ARCH)/g' ./feeds/packages/utils/coremark/Makefile

echo "复制自定义包..."
cp -r $GITHUB_WORKSPACE/package/* ./

echo "修改 argon 主题..."
argon_css_file=$(find ./feeds/luci/themes/luci-theme-argon/ -type f -name "cascade.css" 2>/dev/null | head -1)
if [ -n "$argon_css_file" ]; then
    sed -i "/^.main .main-left .nav li a {/,/^}/ { /font-weight: bolder/d }" "$argon_css_file"
    sed -i '/^\[data-page="admin-system-opkg"\] #maincontent>.container {/,/}/ s/font-weight: 600;/font-weight: normal;/' "$argon_css_file"
    echo "argon 主题修改完成"
else
    echo "未找到 argon 主题，跳过修改"
fi
