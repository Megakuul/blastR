#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Generate image currently 48 MB
dd if=/dev/zero of=bootloader.img bs=512 count=93750

gdisk bootloader.img <<EOF
o
Y
n
1


ef00
w
Y
EOF

mkdosfs -F 32 bootloader.img

mkdir /tmp/loadr
mount -o loop bootloader.img /tmp/loadr
cp -r UEFI/EFI /tmp/loadr
umount /tmp/loadr
rm -rf /tmp/loadr
