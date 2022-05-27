#!/bin/sh

WINDOWS_USER=nzpms
UNIX_USER=nzp

LOGFILE=/mnt/c/Users/$WINDOWS_USER/wsl-backup/$WSL_DISTRO_NAME.log
DEST_DIR=/mnt/c/Users/$WINDOWS_USER/wsl-backup/$WSL_DISTRO_NAME/
SRC_DIR=/home/$UNIX_USER/

EXCLUDE_ITEMS=".vscode-server/,.docker/,.cache/"
EXCLUDE_FILE=/tmp/wsl-backup-exclues

{
    if [ ! -d $DEST_DIR ]; then
        echo "Destination directory for Debian WSL backup does not exist, creating..."
        mkdir -p $DEST_DIR && echo "Created $DEST_DIR"
    fi
} 2>&1 | tee -a $LOGFILE

{
    echo "===== Starting $WSL_DISTRO_NAME backup run @ "`date '+%F %T'`
    echo

    rm -f $EXCLUDE_FILE
    OLDIFS=$IFS
    IFS=,
    for directory in $EXCLUDE_ITEMS; do
        echo "Excluding directory $directory"
        echo $directory >> $EXCLUDE_FILE
    done
    IFS=$OLDIFS

    echo
    echo "Starting rsync run..."
    echo

    rsync -rltD --verbose --delete --exclude-from=$EXCLUDE_FILE $SRC_DIR $DEST_DIR

    echo
    echo "===== Finished $WSL_DISTRO_NAME backup run @ "`date '+%F %T'`
    echo
} 2>&1 | tee -a $LOGFILE
