#!/bin/bash
# pigeon launcher


E="\e[31m"
W="\e[33m"
R="\e[0m"
S="\e[32m"
B="\e[1m"

# static
PREFIX="[pigeon]"
VERSION="1.0-ALPHA"

# directory for servers

pigeon_user="Pigeon"
SERVER_DIR=$(getent passwd "$pigeon_USER" | cut -d: -f6)

