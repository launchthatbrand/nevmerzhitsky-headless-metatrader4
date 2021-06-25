#!/usr/bin/env bash
# Break script on any non-zero status of any command
#set -e

export DISPLAY SCREEN_NUM SCREEN_WHD

XVFB_PID=0
TERMINAL_PID=0

term_handler() {
    echo '########################################'
    echo 'SIGTERM signal received'

    if ps -p $TERMINAL_PID > /dev/null; then
        kill -SIGTERM $TERMINAL_PID
        # Wait returns status of the killed process, with set -e this breaks the script
        wait $TERMINAL_PID || true
    fi

    # Wait end of all wine processes
    /docker/waitonprocess.sh wineserver

    # if ps -p $XVFB_PID > /dev/null; then
    #     kill -SIGTERM $XVFB_PID
    #     # Wait returns status of the killed process, with set -e this breaks the script
    #     wait $XVFB_PID || true
    # fi

    # SIGTERM comes from docker stop so treat it as normal signal
    # exit 0
}

trap 'term_handler' SIGTERM

# Xvfb $DISPLAY -screen $SCREEN_NUM $SCREEN_WHD \
#     +extension GLX \
#     +extension RANDR \
#     +extension RENDER \
#     &> /tmp/xvfb.log &
# XVFB_PID=$!
# sleep 2

mkdir -p /home/winer/.wine/drive_c/windows/Fonts
cp -R /home/winer/.cache/fonts/* /home/winer/.wine/drive_c/windows/Fonts

echo "brand: ${BRAND}"
echo "brand: $BRAND"
echo $BRAND

if [ -z "$BRAND" ]; then
    echo "brand: ${BRAND}"
    cp -R /home/winer/mt4/lvrg /home/winer/.wine/drive_c/mt4
    
    if [ -z "${BRAND}" && -z "${BRAND}" ]; then
        cp -R /home/winer/mt4/products/"${BRAND}"-"${PRODUCT}" /home/winer/.wine/drive_c/mt4/MQL4/Experts
        
    fi
fi   

# @TODO Use special argument to pass value "startup.ini"
# wine ~/.wine/drive_c/mt4/terminal.exe /portable startup.ini &
# TERMINAL_PID=$!

# Wait end of terminal
#*wait $TERMINAL_PID
# Wait end of all wine processes
#*/docker/waitonprocess.sh wineserver
# Wait end of Xvfb
# wait $XVFB_PID


while true; do sleep 1; done