#!/bin/sh
set -e
#set -o pipefail

# Init option
Color_off='\033[0m'       # Text Reset

# terminal color template {{{
# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
# }}}

echo -e $White"welcome to install SpaceVim Kit"$Color_off
echo -e $White"author: huanghy\n"$Color_off

HAVE_GETOPTS=0
VERBOSE=0
TEST=0

if command -v getopts 1>/dev/null
then
    HAVE_GETOPTS=1
fi

# Functions {{{
usage(){
    echo "Usage:"
    echo "  makeide [options]\n"
    echo "Options:"
    echo "  -v          Verbose mode"
    echo "  -t          Don't actually run any recipe; just print them."
    echo "  -h          Print this message and exit"
}

log_e(){
    echo -e "$BRed[LOG] $@$Color_off"
    return 0
}

log_i(){
    echo -e "$BBlue[LOG] $Color_off$@"
    return 0
}

log_d(){
    if [ ${VERBOSE} -eq 1 ]; then
        echo -e "$BYellow[DEBUG] $Color_off$@";
    fi
    return 0
}

install_soft(){
    log_d "${CMD_INSTALL} $@"

    if [ ${TEST} -eq 1 ]; then
        return 0
    fi

    ${CMD_INSTALL} $@
    if [ $? -eq 0 ]; then
        echo "[install] $@ ok!"
    else
        log_e '[install] $@ fail!'
        exit 1
    fi

    return $?
}

#Handle Command line parameters
check_param() {
    if [ ${HAVE_GETOPTS} -eq 1 ];then
        while getopts "vth" opt; do
            case $opt in
                v)
                    log_i "verbose mode"
                    VERBOSE=1
                    ;;
                t)
                    log_i "test mode"
                    TEST=1
                    ;;
                h)
                    usage
                    exit 0
                    ;;
                \?)
                    usage
                    exit 0
                    ;;
            esac
        done
    fi
}

#Check package manager
check_package_manager() {
    if command -v apt-get 1>/dev/null
    then
        log_i 'apt-get is found.'
        PACKAGE_MANAGER="apt-get"
        CMD_INSTALL="apt-get install -y -q"
    elif command -v yum 1>/dev/null
    then
        log_i 'yum is found.'
        PACKAGE_MANAGER="yum"
        CMD_INSTALL="yum install -y"
    elif command -v pacman 1>/dev/null
    then
        log_i 'pacman is found.'
        PACKAGE_MANAGER="pacman"
        CMD_INSTALL="pacman -Sy --needed"
    else
        log_e 'Package manager not found!'
    fi
}

install_zsh() {
    install_soft zsh

    if [ ! -d tmp ]; then
        log_d 'make directory: tmp'
        mkdir tmp
    fi

    #oh-my-zsh
    log_i 'install oh-my-zsh'

    if [ ${TEST} -eq 0 ]; then
        wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O tmp/install.sh
        if [ $? -eq 0 ]; then
            log_i 'download oh-my-zsh ok!'
            sh tmp/install.sh
            if [ $? -eq 0 ]; then
                log_i 'install oh-my-zsh ok!'
            else
                log_e 'install oh-my-zsh fail!'
            fi
        else
            log_e 'download oh-my-zsh fail!'
        fi
    fi
}

install_spacevim() {
    #SpaceVim
    log_i 'install SpaceVim'
    if [ ${TEST} -eq 0 ]; then
        curl -sLf https://spacevim.org/cn/install.sh | bash
    fi
}

main() {
    check_param $@
    check_package_manager
    
    install_soft curl wget git neovim
    install_zsh
    install_spacevim
    
    #install extend software package
    install_soft tig ripgrep lsd htop tree bat
    install_soft fd-find
    install_soft ripgrepp
    
    return 0
}

# }}}

main $@


