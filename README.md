# OpenWrt for FM10 CR6606 + FM350-GL

## 使用说明

1. Fork 本仓库并修改 `.config` 以适配你的需求（如果需要）。
2. Push 到 `main` 分支，GitHub Actions 会自动编译。
3. 编译完成后，在 Actions 的 Artifact 下载固件。
4. 通过路由器刷写固件。
5. 进入 LuCI 界面，配置 5G Modem，使用短信和频段管理功能。

## 脚本使用

`/scripts` 目录包含短信发送和频段锁定脚本，修改设备路径 `/dev/ttyUSB6` 以匹配你的调制解调器设备。
