#!/bin/sh
# 锁定频段 示例，需根据具体运营商调整参数
echo -e "AT+QCFG=\"band\",0,0,800" > /dev/ttyUSB6
