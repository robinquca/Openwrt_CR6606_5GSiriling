#!/bin/bash
set -e
set -x

# 清理旧目录并拉取 5G 插件支持
rm -rf package/wwan
git clone --depth=1 https://github.com/Siriling/5G-Modem-Support package/wwan

# 添加 iStoreOS 源（如果还没添加）
grep -q '^src-git istore' feeds.conf.default || echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
grep -q '^src-git nas ' feeds.conf.default || echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
grep -q '^src-git nas_luci ' feeds.conf.default || echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

# 设置 customfeeds 路径（如果存在才添加）
if [[ -d customfeeds/packages ]]; then
  sed -i '/src-git packages/d' feeds.conf.default
  echo "src-link packages $(realpath customfeeds/packages)" >> feeds.conf.default
fi

if [[ -d customfeeds/luci ]]; then
  sed -i '/src-git luci/d' feeds.conf.default
  echo "src-link luci $(realpath customfeeds/luci)" >> feeds.conf.default
fi
