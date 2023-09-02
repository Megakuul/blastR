# Bootloader

The bootloader is the entrypoint and simply "installes" the operating system on a disk

The code is inside this directory, the UEFI boot image can be built by executing the build.sh script:

```bash
bash build.sh
```

This will generate a FAT32 image. This image can then be run with a x86_64 system that runs UEFI.

With QEMU you can run it like:

```bash
qemu-system-x86_64 -cpu qemu64 -bios OVMF.fd -net none -drive file=bootloader.img,if=ide
```