# blastR - Kernel

The blastR Kernel is a x86_64 compatible Kernel that is compiled into EFI executables. This means that there is no bootloader and ramdisk required, the kernel is directly started by the EFI shell.

To build the EFI executable you can use the Makefile inside this directory:

```bash
make
```

The UEFI boot image can be built by executing the build.sh script:

```bash
bash build.sh 200
```
Notice that the first argument represents the size of the volume partition in Mebibyte.

After running *build.sh* you can use *hotswap.sh* to directly compile, attach and run the QEMU system:

```bash
bash hotswap.sh
```

This will generate a FAT32 image. This image can then be run with a x86_64 system that runs UEFI.

With QEMU you can run it like:

```bash
qemu-system-x86_64 -cpu qemu64 -bios OVMF.fd -net none -drive file=blastr.img,format=raw
```