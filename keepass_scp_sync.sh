#!/bin/bash

## WARNING
# This Script DOES NOT merge two databases. It simply gets the newest file from the server or sends it to it via scp.

## CONFIG
# Username to login as
USER=<user>
# HOST to login to
HOST=<host>
# Path to SSH ID file (private key)
ID=<~/.ssh/private_key>
# Local Directory for Keepass files and backups.
LD=/home/$USER/.keepass
# Local file
LF="$LD/keepassdatabase.kdbx"
# Remote directory
RD=<remoteDir>
# Remote file for download
RF="$RD/keepassdatabase.kdbx"
# Filenames with Date (Remote, Local)
DNFR="`date +%Y%m%d-%H%M%S`R.kdbx"
DNFL="`date +%Y%m%d-%H%M%S`L.kdbx"
# Filename to be downloaded to
DLF="$LD/`date +%Y%m%d-%H%M%S`.kdbx"


# Download via SCP (with original timestamp)
scp -p -i $ID $USER@$HOST:$RF $DLF


if [ -e $LD/keepassdatabase.kdbx ]                      # test for file existence
then                                                    # test for file date
    if [ $DLF -nt $LD/keepassdatabase.kdbx ]            # update local file
    then
        cp $DLF $LD/backup/
        echo Backup of remote file created
        cp $LF $LD/backup/$DNFL
        echo Backup of local file created
        mv $DLF $LD/keepassdatabase.kdbx
        echo Local database has been updated.
    elif [ $DLF -ot $LD/keepassdatabase.kdbx ]          # update remote file
    then
        echo Local database is already up to date.
        scp -p -i $ID $DLF $USER@$HOST:$RD/backup/      # backup DLF to server
        mv $DLF $LD/backup/                             # backup DLF on host
        echo Backup has been created on remote host.
        scp -p -i $ID $LF $USER@$HOST:$RF               # remote DB update
        echo Remote database has been updated.
    else
        rm $DLF
        echo Database is already up to date. Same Version.
    fi
else
    cp $DLF $LD/backup/
    mv $DLF $LD/keepassdatabase.kdbx
    echo Database has been downloaded.
fi
