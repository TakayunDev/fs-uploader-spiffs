#!/bin/sh

cd `dirname $0`

ESP32_PORT=/dev/ttyUSB0
ESPTOOL=$IDF_PATH/components/esptool_py/esptool/esptool.py
MKSPIFFS=$HOME/esp/local/bin/mkspiffs
SRC_FOLDER=./data/
TMP_DIR=./tmp

FS_BLOCK_SIZE_BYTE=0x100000
#FS_BLOCK_SIZE_BYTE=0xf0000
FS_PARTITION_ADDRESS=0x110000

$MKSPIFFS --version

if [ -d "${SRC_FOLDER}" ]; then
  :
else
  echo "[ERR] ${SRC_FOLDER} is not exists."
  exit 1
fi

${MKSPIFFS} \
	-c ${SRC_FOLDER} \
	-b 4096 \
	-p 256 \
	-s ${FS_BLOCK_SIZE_BYTE} \
	${TMP_DIR}/spiffs.bin

${ESPTOOL} \
	--chip esp32 \
	--port ${ESP32_PORT} \
	--baud 115200 \
	write_flash \
		-z \
		${FS_PARTITION_ADDRESS} \
		${TMP_DIR}/spiffs.bin

echo "Finish!"
