#!/usr/bin/env bash

export LD_LIBRARY_PATH=/hive/lib:/usr/local/cuda/lib64/:/usr/local/cuda/lib64/stubs:/hive/miners/custom/epic:$LD_LIBRARY_PATH
export LIBRARY_PATH=/usr/local/cuda/lib64/:/usr/local/cuda/lib64/stubs:$LIBRARY_PATH
export PATH=/usr/local/go/bin:/usr/local/cuda/bin/:$PATH

CUSTOM_DIR=`dirname $0`
cd $CUSTOM_DIR

pkgs='nodejs'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
	curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
	sudo apt-get install -y nodejs
fi

. h-manifest.conf

./TellorMiner mine
