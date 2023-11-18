#!/bin/sh

# Copyright 2022, Nikola Pavlović
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


WINDOWS_USER=nzpms
UNIX_USER=nzp

LOGFILE=/mnt/c/Users/$WINDOWS_USER/wsl-backup/$WSL_DISTRO_NAME.log
DEST_DIR=/mnt/c/Users/$WINDOWS_USER/wsl-backup/$WSL_DISTRO_NAME/
SRC_DIR=/home/$UNIX_USER/

EXCLUDE_ITEMS=".vscode-server/,.docker/,.cache/,.dotnet/,.java/,.local/,.npm/,.nuget/,.omnisharp/,.sage/,.templateengine/,.texlive2020/,.texlive2022/"
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
