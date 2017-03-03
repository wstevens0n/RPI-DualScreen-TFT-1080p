#!/bin/bash

# Set number of seconds to elapse before a default command is executed
TIMEOUTSECONDS=10
echo 0 > /sys/class/backlight/soc:backlight/bl_power

show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    GREEN_TEXT=`echo "\033[32m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e ""
    echo -e ""
    echo -e "${MENU}*******************************************************${NORMAL}"
    echo -e "${GREEN_TEXT}   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`"
    echo -e "${GREEN_TEXT}  '. \ ' ' / .'   `uname -srmo`"
    echo -e "${RED_TEXT}   .~ .~~~..~.    "
    echo -e "${RED_TEXT}  : .~.'~'.~. :   ${NUMBER} 1)${MENU} StartX (HDMI) ${NORMAL}"
    echo -e "${RED_TEXT} ~ (   ) (   ) ~  ${NUMBER} 2)${MENU} StartX (PiTFT) ${NORMAL}"
    echo -e "${RED_TEXT}( : '~'.~.'~' : ) ${NUMBER} 3)${MENU} StartX (TwoDesk)${NORMAL}"
    echo -e "${RED_TEXT} ~ .~ (   ) ~. ~  ${NUMBER} 4)${MENU} *Reboot* ${NORMAL}"
    echo -e "${RED_TEXT}  (  : '~' :  )   ${NUMBER} 5)${MENU} *SHUTDOWN* ${NORMAL}"
    echo -e "${RED_TEXT}   '~ .~~~. ~'    "
    echo -e "${RED_TEXT}       '~'        "
    echo -e "${MENU}*******************************************************${NORMAL}"
    echo -e ""
    echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
    echo -e "${ENTER_LINE}Default: Launch StartX after ${MENU}$TIMEOUTSECONDS seconds${NORMAL}"
    #read from standard input; timeout occurs after $TIMEOUTSECONDS seconds
    read -t $TIMEOUTSECONDS opt
}
function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}
clear
show_menu

    # check for exit code as a result of 'read' timeout
    if [[ $? -ne 0 ]]
    then
    echo -e "${MENU}Menu input - timeout triggered${NORMAL}"
    echo -e "${MENU}Launching X-Windows in 5 seconds ${NORMAL}"
    sleep 5
    # run desired default; match relevant command from the CASE statement, below
    #echo 0 > /sys/class/backlight/soc:backlight/bl_power
    #startx
    echo 1 > /sys/class/backlight/soc:backlight/bl_power
    startx -- -layout HDMI
    # re-load this script so the menu will be present after exiting from X-Windows back to the Terminal
        /home/pi/tools/selector.sh
    fi

    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1) clear;
        option_picked "Launching X-Windows on HDMI";
	echo 1 > /sys/class/backlight/soc:backlight/bl_power
        startx -- -layout HDMI
	# the main Terminal remains running whilst X-Windows loads on another process
	# re-load this script so the menu will be present after exiting from X-Windows back to the Terminal
        /home/pi/tools/selector.sh
	exit;
        ;;
        2) clear;
            option_picked "Launching X-Windows on PiTFT";
	    startx
        /home/pi/tools/selector.sh
	exit;
            ;;
        3) clear;
            option_picked "Launching X-Windows Extended Desktop";
            startx -- -layout TwoDesk
	    /home/pi/tools/selector.sh
	    exit;
            ;;
        4) clear;
            option_picked "Rebooting System";
	sudo reboot;
            ;;
        5) clear;
            option_picked "Shutting Down System";
	sudo shutdown -h now;
	;;
        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
