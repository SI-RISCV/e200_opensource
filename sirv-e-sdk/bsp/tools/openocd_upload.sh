#! /bin/bash -x

openocd -f ${2} \
	-c "flash protect 0 64 last off; program ${1} verify; resume 0x20400000; exit" \
	2>&1 | tee openocd_upload.log
