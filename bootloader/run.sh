#!/bin/bash

# Compile
#gcc -o UEFI/EFI/BOOT/bootx64.efi bootloader.c -nostdlib -shared -Bsymbolic -I /usr/include/efi -I /usr/include/efi/x86_64 -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -Wall -DEFI_FUNCTION_WRAPPER -c

gcc main.c                             \
      -c                                 \
      -fno-stack-protector               \
      -fpic                              \
      -fshort-wchar                      \
      -mno-red-zone                      \
      -I /usr/include/efi 	     	 \
      -I /usr/include/efi/x86_64	 \
      -DEFI_FUNCTION_WRAPPER             \
      -o main.o
 
ld main.o                         \
     /path/to/crt0-efi-x86_64.o     \
     -nostdlib                      \
     -znocombreloc                  \
     -T /path/to/elf_x86_64_efi.lds \
     -shared                        \
     -Bsymbolic                     \
     -L /path/to/libs               \
     -l:libgnuefi.a                 \
     -l:libefi.a                    \
     -o main.so
 
objcopy -j .text                \
          -j .sdata               \
          -j .data                \
          -j .dynamic             \
          -j .dynsym              \
          -j .rel                 \
          -j .rela                \
          -j .reloc               \
          --target=efi-app-x86_64 \
          main.so                 \
          main.efi


# Build ISO
mkisofs -o load.iso -b EFI/BOOT/bootx64.efi -no-emul-boot -boot-load-size 8 -udf UEFI

# Run with QEMU
qemu-system-x86_64 -bios OVMF.fd -cdrom load.iso
