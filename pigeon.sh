#!/bin/bash
# pigeon launcher
PREFIX="[Pigeon]"
VERSION="1.0-ALPHA"

# Colours
E="\033[31m"
W="\033[33m"
R="\033[0m"
S="\033[32m"
B="\033[1m"
J='\033[1;34m'
G="\033[1;37m"


# directory for servers
pigeon_USER="Pigeon"
SERVER_DIR=$(getent passwd "$pigeon_USER" | cut -d: -f6)
declare -a servers=("magnolia")

if [[ $1 == "help" ]]; then
    echo -e "${W}$PREFIX${R} ${J}Pigeon launcher v${VERSION}${R}"
    echo -e "${W}$PREFIX${R} (c) 2026 kurbiis"
    echo -e "${W}$PREFIX${R} ${J}commands:${R}"
    echo -e "${W}$PREFIX${R}    help    ${G}             ${R}       show this help menu"
    echo -e "${W}$PREFIX${R}    setup  ${G}             ${R}        setup pigeon"
    echo -e "${W}$PREFIX${R}    list    ${G}             ${R}       show all running containers"
    echo -e "${W}$PREFIX${R}    spawn   ${G}(server name)${R}       run start script of server in new container"
    echo -e "${W}$PREFIX${R}    start   ${G}(server name)${R}       run start script of server in current container"
    echo -e "${W}$PREFIX${R}    restart ${G}(server name)${R}       run restart script of server"
    echo -e "${W}$PREFIX${R}    stop    ${G}(server name)${R}       run stop script of server"
    echo -e "${W}$PREFIX${R}    kill    ${G}(server name)${R}       kill container of server"
    echo -e "${W}$PREFIX${R}    console ${G}(server name)${R}       open to console of server"
    echo -e "${W}$PREFIX${R} ${J}available servers:${R}"
    for server in ${servers[@]}; do
        echo -e "${W}$PREFIX${R}    $server"
    done
elif [[ $1 == "spawn" ]]; then
    echo -e "${W}$PREFIX${R} spawning $2"
    sudo -u "$pigeon_USER" tmux -S /tmp/tmux_$2 new-session -d -s "$2" -c "$SERVER_DIR/$2" "sh start.sh"
    sudo chgrp admin /tmp/tmux_$2
    sudo chmod 770 /tmp/tmux_$2

elif [[ $1 == "start" ]]; then
    echo -e "${W}$PREFIX${R} starting $2"
    sudo -u "$pigeon_USER" tmux -S /tmp/tmux_$2 send-keys -t "$2" "cd $SERVER_DIR/$2" C-m
    sudo -u "$pigeon_USER" tmux -S /tmp/tmux_$2 send-keys -t "$2" "sh start.sh" C-m

elif [[ $1 == "list" ]]; then
    echo -e "${W}$PREFIX${R} Here's the containers"
    sudo -u $pigeon_USER tmux list-sessions

else
    echo -e "${W}$PREFIX${R} unknown command. see ${S}$0 help${R} for more"
fi