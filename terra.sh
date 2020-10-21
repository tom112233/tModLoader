#!/bin/bash

USERNAME='root'
SCNAME='root'
TERA_VER='1353'
BIN_PATH="/opt/terraria/bin/$TERA_VER/Linux/"
SERVICE='tModLoaderServer.bin.x86_64'
CONFIG='/opt/terraria/serverconfig.txt'


ME=`whoami`

if [ $ME != $USERNAME ] ; then
   echo "Please run the $USERNAME user."
   exit
fi

start() {
   if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
       echo "$SERVICE is already running!"
       exit
   fi

   echo "Starting $SERVICE..."
   screen -AmdS $SCNAME $BIN_PATH$SERVICE -config $CONFIG
   exit
}

stop() {
   if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
       echo "Stopping $SERVICE "
   else
       echo "$SERVICE is not running!"
       exit
   fi

   screen -p 0 -S $SCNAME -X eval 'stuff "say SERVER SHUTTING DOWN IN 10 SECONDS. "\015'
   sleep 10
   screen -p 0 -S $SCNAME -X eval 'stuff "exit"\015'
   exit
}

restart() {
   if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
       echo "Stopping $SERVICE "
   else
       echo "$SERVICE is not running!"
   fi

   screen -p 0 -S $SCNAME -X eval 'stuff "say SERVER SHUTTING DOWN IN 10 SECONDS. "\015'
   sleep 10
   screen -p 0 -S $SCNAME -X eval 'stuff "exit"\015'
   sleep 10   
   start
}

save() {
   echo 'World data saving...'
   screen -p 0 -S $SCNAME -X eval 'stuff "say World saveing..."\015'
   screen -p 0 -S $SCNAME -X eval 'stuff "save"\015'
   exit
}

status() {
   if pgrep -u $USERNAME -f $SERVICE > /dev/null ; then
                echo "$SERVICE is already running!"
                exit
   else
       echo "$SERVICE is not running!"
       exit
        fi
}

case "$1" in
   start)
       start
       ;;
   stop)
       stop
       ;;
   save)
       save
       ;;
   status)
       status
       ;;
   restart)
       restart
       ;;
   *)
       echo  $"Usage: $0 {start|stop|status|save}"
esac
