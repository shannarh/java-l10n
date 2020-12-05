#!/usr/bin/bash
# cd into the directory where this script is located
cd "${BASH_SOURCE%/*}/" || exit

./gradle.sh clean
./gradle.sh --stop
