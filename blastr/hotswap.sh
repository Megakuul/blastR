#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if make; then
	echo "Successfully built kernel-source"
else
	exit $?
fi

if [ ! -e blastr.img ]; then
	echo "Run build.sh before executing this script"
	exit 1
fi

# Create loopdevice for EFI partition
loop_dev=$(losetup --find --show --partscan blastr.img)
loop_efi="${loop_dev}p1"

# Format EFI partition FAT32
mkfs.vfat $loop_efi

# Mounting and copying files to EFI Part
mkdir /tmp/blefi
mount $loop_efi /tmp/blefi
cp -r UEFI/EFI /tmp/blefi
umount /tmp/blefi
rm -rf /tmp/blefi

# Detach loopdevice
losetup -d $loop_dev

# Run Qemu

qemu-system-x86_64 -cpu qemu64 -bios OVMF.fd -net none -drive file=blastr.img,format=raw
