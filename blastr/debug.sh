# This requires SDL display available on the system (on arch its included in the qemu-desktop package)
qemu-system-x86_64 -drive format=raw,file=fat:rw:./UEFI -net none -bios /usr/share/OVMF/x64/OVMF_CODE.fd -display sdl
