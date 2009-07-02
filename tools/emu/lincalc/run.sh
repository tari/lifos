#!/bin/bash
cd tools/emulator/lincalc
echo "Starting LinCalc with ROM file" $1
./Wabbitemu ../../../$1 > /dev/null

