#!/bin/bash
cd tools/emulator/
echo "Starting PTI with ROM file" $1
./pti_frontend --verbose ../../$1
