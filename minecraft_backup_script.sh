#!/bin/bash
x=0
y=0
SCREEN=$(screen -ls | grep -o minecraftjava)

#check for duplicate screen session names, warn and stop the backup script
for session in $(screen -ls | grep -o '[0-9]*\.minecraftjava')
        do let x=x+1
done
if [ $x = 2 ]
        then echo "more than one screen named \"minecraftjava\". use \"screen -list\" to check"
        exit 1
fi

#check for screen session and insert stop command
if [ ! -v $SCREEN ]
        then
                screen -S minecraftjava -p 0 -X stuff "/stop^M"
#               give server time to save before proceeding
                sleep 20
        else
                        echo "server wasn't running, proceeding with backup"
fi

#copy minecraft world to backup folder in number sequence
for FILE in /home/nas-home/BUP/*
        do let y=y+1
done
cp -r /home/nas-home/IvyWood_Manor/ /home/nas-home/BUP/IvyWood_Manor_$y
echo "backup copy number $y successful"

#start server, if none then start new session and check no duplicate name sessions.
if [ ! -v $SCREEN ]
        then
                screen -S minecraftjava -p 0 -X stuff "java -Xmx3000M -Xms3000M -jar server.jar nogui^M"
        else
                        echo "starting new screen for server"
                        screen -S minecraftjava -dm "java -Xmx3000M -Xms3000M -jar server.jar nogui; exec sh"
fi
