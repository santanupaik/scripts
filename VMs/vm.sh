#!/bin/bash

echo "Which VM do you want to start ?"
read -p "Dev(1) Games(2) Anime(3) Windows(4): " userInput

case $userInput in
    1)
        echo "Starting Dev VM..."
        vm=dev
        ;;
    2)
        echo "Starting Games VM..."
        vm=games
        ;;
    3)
        echo "Starting Anime VM..."
        vm=anime
        ;;
    4)
        echo "Starting Windows VM..."
        vm=win10
        ;;
    *)
        echo "Invalid option selected."
        exit 0
        ;;
esac

qemu-system-x86_64 \
-enable-kvm \
-M q35 \
-m 8192 -smp 4 -cpu host \
-bios /usr/share/edk2/x64/OVMF_CODE.fd \
-cdrom "$HOME"/VM/iso/manjaro.iso \
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
-global ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1

#EOF#
