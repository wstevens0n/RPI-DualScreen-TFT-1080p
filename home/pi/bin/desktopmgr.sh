#!/bin/bash
#
# Start the LXDE desktop environment on the secondary display in a Dual-Head setup, where Xinerama is OFF.
#

export SECONDARY_DISPLAY=:0.1
export LXDE_CONF_DIR=$HOME/.config/pcmanfm/LXDE-pi         # Directory under ~/.config/pcmanfm/ with LXDE configuration for this desktop.
export OPENBOX_CONFIG=$HOME/.config/openbox/lxde-pi-rc.xml

#xsetroot -display ${SECONDARY_DISPLAY} -solid thistle # For debug. If the secondary screen changes colour, we know that this script is running.

# Start a window manager.
DISPLAY=${SECONDARY_DISPLAY} openbox --config-file ${OPENBOX_CONFIG} &

# Start the desktop environment (wallpaper and desktop icons). It is actually the file manager pcmanfm that manages the desktop, when started with its --desktop option.
#
# Alas, there is a bug in pcmanfm.
# It won't start on DISPLAY :0.1 if there already is another pcmanfm running on the main DISPLAY :0.0
# It seems like it only checks if it already is running on the same X server,
# not taking the possible multiple displays on that server into consideration.
# Workaround by using the DISPLAY environment variable to point to a non-existing DISPLAY :9.0, where it does its check-if-i-am-already-running
# and using the --display argument to point out the real DISPLAY we want it running on.

DISPLAY=:9.0 pcmanfm --display=${SECONDARY_DISPLAY} --desktop  --profile LXDE &

# Start a terminal in the lower left corner of the display.
cd $HOME   # To make the terminal open in our home directory.
xterm -bg LightGoldenrodYellow -fg black -geometry +0-0 -display :0.1 &

# A clock is always nice to have.
DISPLAY=${SECONDARY_DISPLAY} xclock  -geometry +150+10 &

# Shrink the touch area. By default the Adafruit touchscreen will map to the entire X server screen area (both displays.)
# We need to shrink the touch area into a rectangle which is smaller than the total screen. 
#
# The below transformation is for an Adafruit PiTFT 320x240 monitor to the left of a 1680x1050 monitor. The two monitors are aligned at the bottom edges.
# The touch area is shrunk to only encompass the Adafruit monitor.
# If your setup differs at all from the above, you have to recalculate the transformation.
# All the nitty, gritty details at https://wiki.archlinux.org/index.php/Calibrating_Touchscreen
# You have to "sudo apt-get install xinput" for the next line to work...

xinput set-prop "stmpe-ts" --type=float "Coordinate Transformation Matrix" 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000

