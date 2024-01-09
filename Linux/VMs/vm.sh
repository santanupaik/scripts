#!/bin/bash

echo "Which VM do you want to start ?"
printf "Webdev(1) Dev (2) Win10(3) BoysTrip(4) Romdev(5): "
read str0

if [ $str0 == 1 ]; then
    echo "Starting Webdev VM..."
    vm=webdev

elif [ $str0 == 2 ]; then
    echo "Starting Dev VM..."
    vm=dev

elif [ $str0 == 3 ]; then
    echo "Starting Win10 VM..."
    vm=win10
   
elif [ $str0 == 4 ]; then
    echo "Starting BoysTrip VM..."
    vm=boystrip

elif [ $str0 == 5 ]; then
    echo "Starting Romdev VM..."
    vm=romdev
fi

qemu-system-x86_64 \
-enable-kvm \
-M q35 \
-m 8192 -smp 4 -cpu host \
-bios /usr/share/edk2/x64/OVMF_CODE.fd \
-cdrom /home/nerd/VM/iso/manjaro.iso \
-usb \
-device usb-host,vendorid="0xvid1",productid="0xpid1" \
-device usb-host,vendorid="0xvid2",productid="0xpid2" \
-device usb-host,vendorid="0xvid3",productid="0xpid3" \
-device virtio-tablet \
-device virtio-keyboard \
-device qemu-xhci,id=xhci \
-machine vmport=off \
-device virtio-vga-gl -display sdl,gl=on \
-device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 \
-global ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 \
#-device usb-storage,drive=stick,id=usbstick \
#-drive if=none,id=stick,format=raw,file=/dev/sdb
#EOF#
