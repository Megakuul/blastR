#include <efi.h>
#include <efilib.h>

void load_kernel() {

}

EFI_STATUS EFIAPI efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
    InitializeLib(ImageHandle, SystemTable);

	// Clear Screen
	uefi_call_wrapper(SystemTable->ConOut->ClearScreen, 1, SystemTable->ConOut);

	Print(L"PRESS ESC TO INTERUPT OR ANY OTHER KEY TO LAUNCH BLASTR KERNEL\n");

	EFI_INPUT_KEY key;
    EFI_STATUS status;

    do {
        status = uefi_call_wrapper(SystemTable->ConIn->ReadKeyStroke, 2, SystemTable->ConIn, &key);
        uefi_call_wrapper(SystemTable->BootServices->Stall, 1, 1000);
    } while (status == EFI_NOT_READY);

	if (key.ScanCode == SCAN_ESC) {
	   Print(L"EXITING BLASTR...\n");
	   return EFI_SUCCESS;
	}

    Print(L"UEFI RUNTIME IS ABOUT TO BE SHUTDOWN\n");

	uefi_call_wrapper(SystemTable->BootServices->Stall, 2000000);
	//	uefi_call_wrapper(SystemTable->ExitBootServices, ImageHandle, MemoryMapKey);

    load_kernel();

    return EFI_SUCCESS;
}

