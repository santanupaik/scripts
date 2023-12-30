#!/bin/bash
# Setting Variables
VUDIR=/home/$USER/VMs/VUSB/

# Initial Options #
echo
echo "Do you want to Mount or Unmount the Virtual USB Drive ?"
printf "Mount(1) Unmount(2) Quit(q): "
read str0

# Checking if Virtual USB is already mounted or not #
$(lsblk | grep -q loop0)
chkld=$(echo $?)

# USB mounting & unmounting Sequence #
if [ $chkld == 0 ] && [ $str0 == 1 ]; then
    echo "Virtual USB already Mounted ? Aborting !"
    sleep 1s
    exit 0
    
elif [ $str0 == 1 ]; then
    echo
    printf "Enter the VUSB Drive Name (Excluding '.img'): "
    read VUNAME
    echo "Mounting Virtual USB Drive....."
    sleep 1s
    udisksctl loop-setup -f $VUDIR/$VUNAME.img
    udisksctl mount -b /dev/loop0p1
    
elif [ $chkld == 1 ] && [ $str0 == 2 ]; then
    echo "Virtual USB is not mounted ? Aborting !"
    sleep 1s
    exit 0
    
elif [ $str0 == 2 ]; then
    echo "Unmounting Virtual USB Drive....."
    sleep 1s
    udisksctl unmount -b /dev/loop0p1
    udisksctl loop-delete -b /dev/loop0
    
elif [ $str0 == q ]; then
    printf "Quitting....."
    echo
    sleep 1s
    
else
    echo
fi

# EOF #
