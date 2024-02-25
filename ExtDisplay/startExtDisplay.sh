#!/bin/bash

#Setup Variables
secondaryDisplay="HDMI-1"
mainDisplay="eDP-1"

# $1 = resolution $2 = framerate $3 = add addition arguments to xrandr
setRes () {
    xrandr --output $secondaryDisplay --off
    xrandr --output $secondaryDisplay --mode $1 --pos 0x0 --rotate normal --rate $2 $3
}

checkDisplay () {
    xrandr --listmonitors --verbose | grep -q "$secondaryDisplay disconnected"
    if [ $? == 1 ]
    then
        echo "$secondaryDisplay is connected"
    else
        clear
        echo "$secondaryDisplay is disconnected"
        sleep 1
        exit 0
    fi
}

PS3="Enter your choice: "
options=("Mirror Display" "Use as second display" "Reset $secondaryDisplay" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Mirror Display")
            checkDisplay
            clear
            PS3="Enter your choice: "
            options=("1920x1080x60" "custom" "cancel")
            select opt in "${options[@]}"
            do
                case $opt in
                    "1920x1080x60")
                        setRes "1920x1080" "60"
                        echo 'awesome.restart()' | awesome-client
                        exit
                        ;;
                    "custom")
                        xrandr
                        echo -n "Enter custom resolution (Eg:1920x1080): " 
                        read res
                        echo -n "Enter custom framerate (Eg:60): " 
                        read fps
                        setRes $res $fps
                        echo 'awesome.restart()' | awesome-client
                        exit 0
                        ;;
                    "cancel")
                        exit 0
                        ;;
                    *) echo "invalid option $REPLY";;
                esac
            done
            break
            ;;
        "Use as second display")
            checkDisplay
            clear
            PS3="Enter your choice: "
            options=("1920x1080x60" "custom" "cancel")
            select opt in "${options[@]}"
            do
                case $opt in
                    "1920x1080x60")
                        setRes "1920x1080" "60" "--left-of $mainDisplay"
                        echo 'awesome.restart()' | awesome-client
                        exit 0
                        ;;
                    "custom")
                        xrandr
                        echo -n "Enter custom resolution (Eg:1920x1080): " 
                        read res
                        echo -n "Enter custom framerate (Eg:60): " 
                        read fps
                        setRes $res $fps "--left-of $mainDisplay"
                        echo 'awesome.restart()' | awesome-client
                        exit 0
                        ;;
                    "cancel")
                        exit 0
                        ;;
                    *) echo "invalid option $REPLY";;
                esac
            done
            break
            ;;
        "Reset $secondaryDisplay")
            xrandr --output $secondaryDisplay --off
            echo 'awesome.restart()' | awesome-client
            exit 0
            ;;
        "Cancel")
            exit 0
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
