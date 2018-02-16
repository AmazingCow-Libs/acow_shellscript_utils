
##----------------------------------------------------------------------------##
## Path Utilities                                                             ##
##----------------------------------------------------------------------------##
get_script_dir()
{
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)";
    echo "$SCRIPT_DIR";
}


##----------------------------------------------------------------------------##
## Text Utilities                                                             ##
##----------------------------------------------------------------------------##
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