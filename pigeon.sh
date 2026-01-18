#!/bin/bash
# pigeon launcher

# colors
J='\033[1;34m'
G='\033[0;37m'
H='\033[1;32m'
R='\033[0m'

E="\e[31m"
W="\e[33m"
R="\e[0m"
S="\e[32m"
B="\e[1m"


# static
PREFIX="[pigeon]"
VERSION="0.1"
# directory for servers
SERVER_DIR="/home/pigeon"
pigeon_USER="pigeon"
# make each name the name of the directory that is inh /home/servers/
declare -a servers=("magnolia")

if [[ $1 == "help" ]]; then
    echo -e "${W}$PREFIX${R} ${J}pigeon launcher v${VERSION}"
    echo -e "${W}$PREFIX${R} (c) 2026 orchidtowny"
    echo -e "${W}$PREFIX${R} ${J}commands:"
    echo -e "${W}$PREFIX${R}    help    ${G}             ${R}       show this help menu"
    echo -e "${W}$PREFIX${R}    list    ${G}             ${R}       show all running containers"
    echo -e "${W}$PREFIX${R}    spawn   ${G}(server name)${R}       run start script of server in new container"
    echo -e "${W}$PREFIX${R}    start   ${G}(server name)${R}       run start script of server in current container"
    echo -e "${W}$PREFIX${R}    restart ${G}(server name)${R}       run restart script of server"
    echo -e "${W}$PREFIX${R}    stop    ${G}(server name)${R}       run stop script of server"
    echo -e "${W}$PREFIX${R}    kill    ${G}(server name)${R}       kill container of server"
    echo -e "${W}$PREFIX${R}    console ${G}(server name)${R}       open to console of server"
    echo -e "${W}$PREFIX${R} ${J}available servers:"
    for server in ${servers[@]}; do
        echo -e "${W}$PREFIX${R}    $server"
    done
elif [[ $1 == "start" ]]; then
    echo -e "${W}$PREFIX${R} starting $2"
    sudo -u $pigeon_USER screen -S $2 -X stuff 'cd '$SERVER_DIR'/'$2'\r sh start.sh\r'
elif [[ $1 == "spawn" ]]; then
    echo -e "${W}$PREFIX${R} spawning $2"
    sudo -u $pigeon_USER screen -dmS $2 bash -c 'cd '$SERVER_DIR'/'$2'; sh start.sh; exec bash;'
    sudo -u $pigeon_USER screen -S $2 -X multiuser on
    for admin in ${admins[@]}; do
        sudo -u $pigeon_USER screen -S $2 -X acladd $admin
    done
elif [[ $1 == "restart" ]]; then
    echo -e "${W}$PREFIX${R} restarting $2"
    sudo -u $pigeon_USER screen -S $2 -X eval 'stuff "restart\015"'
elif [[ $1 == "stop" ]]; then
    echo -e "${W}$PREFIX${R} stopping $2"
    sudo -u $pigeon_USER screen -S $2 -X eval 'stuff "stop\015"'
elif [[ $1 == "command" ]]; then
    echo -e "${W}$PREFIX${R} running command '${@:3}' on $2"
    sudo -u $pigeon_USER screen -S $2 -X eval 'stuff "'"${*:3}"'\015"'
elif [[ $1 == "kill" ]]; then
    read -r -p "$(echo -e ${W}$PREFIX${R}" you're about to kill a process ("$2"). this could lead to data corruption, would you like to continue? "${H}"[y/N]"${R}) " response
    case "$response" in
    [yY][eE][sS] | [yY])
        echo -e "${W}$PREFIX${R} killed process $2 and removed it's container."
    sudo -u $pigeon_USER screen -S $2 -X kill
        ;;
    *)
        echo -e "${W}$PREFIX${R} cancelling, $2 was not killed."
        ;;
    esac
elif [[ $1 == "console" ]]; then
    echo -e "${W}$PREFIX${R} opening console of $2"
    echo -e "${W}$PREFIX${R} "
    echo -e "${W}$PREFIX${R} ${J}!! IMPORTWNT !!"
    echo -e "${W}$PREFIX${R} do not use ${H}ctrl + c${R}."
    echo -e "${W}$PREFIX${R} to exit a container always use ${H}ctrl + b${R} & ${H}d${R}."
    echo -e "${W}$PREFIX${R} to copy to clipboard always use ${H}ctrl + shift + c${R}."
    echo -e "${W}$PREFIX${R} "
    read -r -p "$(echo -e ${W}$PREFIX${R}" "${G}"press enter to continue")"
    sudo -u $pigeon_USER screen -x $2
elif [[ $1 == "list" ]]; then
    echo -e "${W}$PREFIX${R} here's all the containers"
    sudo -u $pigeon_USER screen -ls
else
    echo -e "${W}$PREFIX${R} unknown command. see ${H}$0 help${R} for more"
fi
