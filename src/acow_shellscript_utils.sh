##~---------------------------------------------------------------------------##
##                     _______  _______  _______  _     _                     ##
##                    |   _   ||       ||       || | _ | |                    ##
##                    |  |_|  ||       ||   _   || || || |                    ##
##                    |       ||       ||  | |  ||       |                    ##
##                    |       ||      _||  |_|  ||       |                    ##
##                    |   _   ||     |_ |       ||   _   |                    ##
##                    |__| |__||_______||_______||__| |__|                    ##
##                             www.amazingcow.com                             ##
##  File      : acow_shellscript_utils.sh                                     ##
##  Project   : TSP                                                           ##
##  Date      : Feb 24, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : n2omatt <n2omatt@amazingcow.com>                              ##
##  Copyright : AmazingCow - 2018                                             ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Colors                                                                     ##
##----------------------------------------------------------------------------##
CL_RST="\033[0m"
# Foreground
FG_K="\033[030m"
FG_R="\033[031m"
FG_G="\033[032m"
FG_Y="\033[033m"
FG_B="\033[034m"
FG_M="\033[035m"
FG_C="\033[036m"
FG_W="\033[037m"
# Background
BG_K="\033[40m"
BG_R="\033[41m"
BG_G="\033[42m"
BG_Y="\033[43m"
BG_B="\033[44m"
BG_M="\033[45m"
BG_C="\033[46m"
BG_W="\033[47m"

FK() { echo -e "${FG_K}$@${CL_RST}"; }
FR() { echo -e "${FG_R}$@${CL_RST}"; }
FG() { echo -e "${FG_G}$@${CL_RST}"; }
FY() { echo -e "${FG_Y}$@${CL_RST}"; }
FB() { echo -e "${FG_B}$@${CL_RST}"; }
FM() { echo -e "${FG_M}$@${CL_RST}"; }
FC() { echo -e "${FG_C}$@${CL_RST}"; }
FW() { echo -e "${FG_W}$@${CL_RST}"; }

BK() { echo -e "${BG_K}$@${CL_RST}"; }
BR() { echo -e "${BG_R}$@${CL_RST}"; }
BG() { echo -e "${BG_G}$@${CL_RST}"; }
BY() { echo -e "${BG_Y}$@${CL_RST}"; }
BB() { echo -e "${BG_B}$@${CL_RST}"; }
BM() { echo -e "${BG_M}$@${CL_RST}"; }
BC() { echo -e "${BG_C}$@${CL_RST}"; }
BW() { echo -e "${BG_W}$@${CL_RST}"; }

remove_color_sequences()
{
    echo "$1" | sed 's/\x1b\[[0-9;]*m//g';
}


##----------------------------------------------------------------------------##
## Path Utilities                                                             ##
##----------------------------------------------------------------------------##
get_script_dir()
{
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)";
    echo "$SCRIPT_DIR";
}

get_user_home()
{
    local USER="$1";
    test -z "$USER" && USER=$(whoami);

    echo $(getent passwd "$USER" | cut -d: -f6);
}


##----------------------------------------------------------------------------##
## Text Utilities                                                             ##
##----------------------------------------------------------------------------##
trim()
{
    echo "$1" | xargs
}
to_lower()
{
    echo $(echo $1 | tr [:upper:] [:lower:]);
}

center_text()
{
    local TEXT="$1";
    local FILL="$3";
    local COLS=$(tput cols);
    local TEXT_LEN=${#TEXT};

    test -z "$FILL" && FILL="-";
    local FILL_LEN=${#FILL};
    local FILL_LEN2=$(( FILL_LEN * 2 ));

    local FILL_TIMES=$(( COLS / FILL_LEN2  - TEXT_LEN / 2 ));
    local FILL_LINE="";

    for i in $(seq 1 $FILL_TIMES); do
        FILL_LINE+=$FILL;
    done

    echo -n "${FILL_LINE}${TEXT}${FILL_LINE}";
}


##----------------------------------------------------------------------------##
## Logs                                                                       ##
##----------------------------------------------------------------------------##
fatal()
{
    echo "[FATAL] $@";
    exit 1;
}


as_super_user()
{
    local SUDO="";
    test $UID != 0 && SUDO="sudo ";
    
    $SUDO "$@";
}

find_real_user_home()
{
    local REAL_USER_HOME="";

    if [ $UID == 0 ]; then
        local USER=$(printenv SUDO_USER);
        if [ -z "$USER" ]; then            
            REAL_USER_HOME="$HOME";
        else
            REAL_USER_HOME=$(getent passwd "$USER" | cut -d: -f6);
        fi;
    else    
        REAL_USER_HOME="$HOME";
    fi;

    echo "$REAL_USER_HOME";
}