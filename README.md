# Keepass SCP sync
Synchronize Keepass databases via SCP

## Script Procedure
* download file from remote host (RF)
* compare
  * RemoteFile newerthan LocalFile (RF nt LF)
    * backup LF
    * save RF as new
  * RemoteFile olderthan LocalFile (RF ot LF)
    * backup RF on server (scp DLF to server/backup)
    * upload LF to server

## Installation
1. Clone or copy script
2. Change settings under #Config to satisfy your needs.

## ToDos
- add -P 2264 port parameter
- add key exchange
- check for backup folder existence
- use rsync instead?
- make use of DNLF DNRF
- add user for remote and local
- check for keyfile
