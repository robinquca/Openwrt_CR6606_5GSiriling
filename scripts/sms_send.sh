#!/bin/sh
# 发送短信 示例
echo -e "AT+CMGF=1\r" > /dev/ttyUSB6
sleep 1
echo -e "AT+CMGS=\"+1234567890\"\r" > /dev/ttyUSB6
sleep 1
echo -e "测试短信内容\x1A" > /dev/ttyUSB6
