# RPI-DualScreen-TFT-1080p

Raspberry Pi Dual Screen Project (1080p + 3.5 TFT)

This is a project utilizing Adafruit 3.5 480x320 PiTFT, together with an HP 1920x1080 monitor on the RPi's HDMI port.

Upon boot a menu will appear providing user the option to select perferred desktop configuration (home/pi/bin/selector.sh).

![img_20170302_231500](https://cloud.githubusercontent.com/assets/25314348/23539352/60e9b2a2-ffa0-11e6-89e5-9fc6ed780916.jpg)

Menu will timeout after 10 seconds and default to HDMI output.

You may change this to default to TFT by commenting and uncommenting the following code.

    #echo 0 > /sys/class/backlight/soc:backlight/bl_power
    #startx
    echo 1 > /sys/class/backlight/soc:backlight/bl_power
    startx -- -layout HDMI
    
This github project is shared as reference material for configuring their own extended display project.


Resources obtained from:

Adafruit DYI Installer Script
https://learn.adafruit.com/adafruit-pitft-3-dot-5-touch-screen-for-raspberry-pi/easy-install

Dual screen HDMI and 2.8 PiTFT (ragnarjensen's post)
https://www.raspberrypi.org/forums/viewtopic.php?f=44&t=91764&start=50

Multipurpose Raspberry Pi – Part 2: Adding a Menu to Access RetroPie, Kodi, and the Raspbian Desktop (Retro Resolution Blog)
https://retroresolution.com/2016/04/19/multipurpose-raspberry-pi-part-2-adding-a-menu-to-access-retropie-kodi-and-the-raspbian-desktop/
