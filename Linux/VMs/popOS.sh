#!/bin/bash
sway output HDMI-A-1 mode 1920x1080@60Hz position 1920 430 adaptive_sync on
qemu-system-x86_64 \
-enable-kvm \
-M q35 \
-m 8912 -smp 4 -cpu host \
-bios /usr/share/edk2/x64/OVMF_CODE.fd \
-drive file=/home/$USER/vm/fs/popOS.qcow2,if=virtio \
-usb \
-device virtio-tablet \
-device virtio-keyboard \
-device qemu-xhci,id=xhci \
-machine vmport=off \
-device virtio-vga-gl -display sdl,gl=on \
-device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 \
-global ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1
sway output HDMI-A-1 mode 1920x1080@75Hz position 1920 430 adaptive_sync on
#EOF#
