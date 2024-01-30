# blastR - Kernel

The blastR Kernel is a x86_64 compatible Kernel that is compiled into EFI executables. This means that there is no bootloader and ramdisk required, the kernel is directly started by the EFI shell.

**Prerequisites**:
- qemu
- qemu-desktop
- ovmf
- gcc
- gnu efi headers

On Arch you can install them like this:

```bash
sudo pacman -S base-devel gcc qemu qemu-desktop edk2-ovmf
yay -S gnu-efi-libs
```

### Installation

To build a virtual disk containing the system, compile and run the build script:

```bash
make
bash build.sh 200
```
Notice that the first argument represents the size of the volume partition in Mebibyte.


Alternative you can also just compile and copy the contents of the *UEFI* output folder to a ISO file and then boot from there on.


### Development

To build the EFI executable you can use the Makefile inside this directory:

```bash
make
```

Then you can run the kernel by using qemu with the OVMF firmware

```bash
qemu-system-x86_64 -drive format=raw,file=fat:rw:./UEFI -net none -bios /usr/share/OVMF/x64/OVMF_CODE.fd -display sdl
```
(Note that the OVMF can also be located in a different location depending on your configuration)
