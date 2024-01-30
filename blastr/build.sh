#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ -z "$1" ]; then
	echo "Usage: $0 <VolumeSizeInMiB>"
	exit 1
fi

efi_sz=99+1 # + 1 block for GPT Offset
img_sz=$(( $1+100 ))
blk_sz=1048576 # 1 Mebibyte

# GPT block size
gpt_blk_sz=512 # Default block size
# GPT block offset
gpt_blk_of=2048 # Default gpt offset

echo "Image is generated [EFI: 99 MB] [VOL: $1 MB] ..."

# Create Image
dd if=/dev/zero of=blastr.img bs=$blk_sz count=$img_sz

# Generate EFI & Volume partitions
fdisk blastr.img <<EOF
g
n


+99M
t
ef00
n



w
EOF

# Create loopdevice for EFI partition
loop_dev=$(losetup --find --show --partscan blastr.img)
loop_efi="${loop_dev}p1"
loop_vol="${loop_dev}p2"

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
