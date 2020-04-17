# README #

zfs-auto-snapshot script creates automatic snapshots of all zfs filesystems and volumes.  
The script will automatically rotate snapshots deleting old ones.  
The script will temporarily avoid backups on damaged pools or pools with scrubbing going on.

It creates:  
4 snapshots per hour to rotate every 15 minutes  
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

in src folder, before installing, you can customize some parameters  
--keep indicates the number of snapshots to save. Default to 10
--label indicates the label of snapshots. Default to defaultLabel
--threshold indicates how many bytes need to be written in a dataset after the last snapshot to allow new snapshots. Default 0 

