#!/usr/bin/env bash

# [[ -z $CUSTOM_TEMPLATE ]] && echo -e "${YELLOW}CUSTOM_TEMPLATE is empty${NOCOLOR}" && return 1
# [[ -z $CUSTOM_URL ]] && echo -e "${YELLOW}CUSTOM_URL is empty${NOCOLOR}" && return 1

CUSTOM_URL="${CUSTOM_URL%/}"

URL_CUSTOM=$(echo $CUSTOM_URL | cut -d":" -f1)
PORT_CUSTOM=$(echo $CUSTOM_URL | cut -d":" -f2)

NVIDIA_COUNT=$(nvidia-smi -L | wc -l)
NVIDIA_STRING=""
for ((i=0; i < $NVIDIA_COUNT; i++)); do
    NVIDIA_STRING=$NVIDIA_STRING$i
    if [ $i -lt $[$NVIDIA_COUNT - 1] ]; then
        NVIDIA_STRING=$NVIDIA_STRING,
    fi
done

# conf="--address=${CUSTOM_TEMPLATE} --server=$URLCUSTOM --port=$PORTCUSTOM ${CUSTOM_USER_CONFIG}"
# conf="${CUSTOM_USER_CONFIG}"

conf="${CUSTOM_USER_CONFIG}"
# replace tpl values in whole file
# [[ -z $EWAL && -z $ZWAL && -z $DWAL ]] && echo -e "${RED}No WAL address is set${NOCOLOR}"
[[ ! -z $EWAL ]] && conf=$(sed "s/%EWAL%/$EWAL/g" <<< "$conf") #|| echo "${RED}EWAL not set${NOCOLOR}"
[[ ! -z $DWAL ]] && conf=$(sed "s/%DWAL%/$DWAL/g" <<< "$conf") #|| echo "${RED}DWAL not set${NOCOLOR}"
[[ ! -z $ZWAL ]] && conf=$(sed "s/%ZWAL%/$ZWAL/g" <<< "$conf") #|| echo "${RED}ZWAL not set${NOCOLOR}"
[[ ! -z $EMAIL ]] && conf=$(sed "s/%EMAIL%/$EMAIL/g" <<< "$conf")
[[ ! -z $NVIDIA_STRING ]] && conf=$(sed "s/%GPUS%/$NVIDIA_STRING/g" <<< "$conf")
[[ ! -z $CUSTOM_TEMPLATE ]] && conf=$(sed "s/%WALLET%/$CUSTOM_TEMPLATE/g" <<< "$conf")
[[ ! -z $URL_CUSTOM ]] && conf=$(sed "s/%URL_CUSTOM%/$URL_CUSTOM/g" <<< "$conf")
[[ ! -z $PORT_CUSTOM ]] && conf=$(sed "s/%PORT_CUSTOM%/$PORT_CUSTOM/g" <<< "$conf")
[[ ! -z $WORKER_NAME ]] && conf=$(sed "s/%WORKER_NAME%/$WORKER_NAME/g" <<< "$conf") #|| echo "${RED}WORKER_NAME not set${NOCOLOR}"

# [[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
# [[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1

echo "${conf}" > $CUSTOM_CONFIG_FILENAME
