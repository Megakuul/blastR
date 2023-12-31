# Variables
SOURCE = src/main.c
OBJECT = blastr.o
OUTPUTDIR = UEFI/EFI/BOOT
OUTPUT = BOOTX64.EFI
# Librarys are set to debian/ubuntu libs, on other distributions they may be elsewhere
EFISUPPORT = /usr/lib/crt0-efi-x86_64.o
EFIINC = /usr/include/efi
EFIINC_X64 = /usr/include/efi/x86_64
EFILIB = /usr/lib
EFILDS = /usr/lib/elf_x86_64_efi.lds

# Build flags
CFLAGS = -c -fno-stack-protector -fpic -fshort-wchar -mno-red-zone -I $(EFIINC) -I $(EFIINC_X64) -DEFI_FUNCTION_WRAPPER
LDFLAGS = -nostdlib -znocombreloc -T $(EFILDS) -shared -Bsymbolic -L $(EFILIB) -l:libgnuefi.a -l:libefi.a
OBJCOPYFLAGS = -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .reloc --target=efi-app-x86_64

# Rules
all: $(OUTPUT) move

$(OUTPUT): blastr.so
	objcopy $(OBJCOPYFLAGS) $< $@

blastr.so: $(OBJECT)
	ld $(OBJECT) $(EFISUPPORT) $(LDFLAGS) -o $@

$(OBJECT): $(SOURCE)
	gcc $(CFLAGS) $< -o $@

move:
	mv $(OUTPUT) $(OUTPUTDIR)

clean:
	rm -f $(OBJECT) blastr.so $(OUTPUT)

.PHONY: all clean
