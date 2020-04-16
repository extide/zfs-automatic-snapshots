# README #

zfs-auto-snapshot script allow automatic snapshots of all zfs filesystems and volumes.  
The script will automatically rotate snapshots deleting old ones.  
The script will temporarily avoid backups on damaged pools or pools with scrubbing going on.

It creates:  
4 snapshots for hour to rotate every 15 min  
24 hourly snapshots  
30 daily snapshots  
12 weekly snapshots  
12 yearly snapshots  

Script has been tested on zfs on linux 0.8.3, centos 7  
Original script from https://github.com/zfsonlinux/zfs-auto-snapshot  
I semplified the code and fixed some bugs  

# to install
cd to current folder  
make install

# to uninstall
cd to current folder  
make uninstall

# NOTE #
uninstalling the script doesn't delete made snapshots

