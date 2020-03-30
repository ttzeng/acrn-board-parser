#!/bin/bash

BOARD='unknown'
DMI_BOARD_NAME='/sys/class/dmi/id/board_name'
if [ -f $DMI_BOARD_NAME ]; then
    BOARD=`cat $DMI_BOARD_NAME`
fi

cd /opt/workspace/acrn-hypervisor/misc/acrn-config/target
python board_parser.py ${BOARD,,}
