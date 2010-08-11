#!/bin/bash
cd tools/emu/
echo "Starting PTI with ROM file" $1
chmod +x ./pti_frontend
./pti_frontend --verbose ../../$1
