# Minimal POSIX Test (minipsx)

This project was designed to test out the functionalities of a hypotetical POSIX/Linux subsystem for the NT kernel (powered by ReactOS), 
as well as a bedtest for developing with the NT Native Development Kit (NDK)

The scope of the subsystem is to bootup a POSIX-like environment without relying on the Windows userland subsystem (win32k.sys), by fact
this system does not load Win32k.sys or any other Win32 user-land components.

The directory "system32" has been removed (SYSTEMHIVE has been adjusted, hardcoded paths have been removed from the NT kernel) and moved to a more UNIX-like
directory structure (altrough this changes were done as a pure test on the kernel and are not required for the POSIX translation layer)

The implementation of the UNIX layer can be seen as aa similar style to WSL1 mixed with functionalities from SFU 3.5.
MiniPSX does not target ELF/normal executables like WSL does, but it does contain a kernel-land driver translation like WSL.
It does read NT Native executables with POSIX subsystem like SFU does, but it does not rely on user-land code to convert syscalls.

Altrough the code might be compatible with running both win32k and this subsystem (assuming you actually have Pico process or I find another way of storing the POSIX contexts without touching win32k), there is currently no will/support for integrating this layer into a normal Windows environment, considering syscall dispatcher would not even work due to hard-core limitations of Windows 7+.

## Architecture of the POSIX subsystem

### lxcore.sys
This is the hearth of the POSIX/Linux translation layer from POSIX routines to NT Native routines.
This component acts very similar to what lxcore.sys does, altrough lxcore.sys has some differences:
- Lack of any VFS support: MiniPSX will convert paths to normal NT directories like Win32 api does. This might change but there is not enough documentation for LxVfs routines
- Lack of Pico process support: Altrough some preliminary code for Picoprocess exists, ReactOS lacks any support for this feature therefore no support will be provided for normal Linux ELF
- Lack of LPC and communication with LxssManager: There is simply no need to implement support for LxssManager as we don't have either Win32k or Picoprocess
- Support for Win32 contexts: This is required for supporting replacements of win32k.sys

### lxss.sys
Like WSL1, lxss.sys is a simple driver that registers the lxcore components, it's also responsable to be registred as the Kernel mode executor completely replacing win32k.sys. LXSS makes heavy use of LXCore for it's functionalities.

LXSS operations can be summed up in two steps:
1. Call LxInitialize to initialize lxcore.sys
2. Register itself as the win32k callout handler, replacing/emulating win32k.sys functionality

### psxdll.dll
This is a customized version of MUSL to provide a normal C runtime to the POSIX applications.
This component makes use of ntdll.dll for calling service 2 syscalls (the one registred by lxss.sys), the original "syscall"
in MUSL becomes the syscall handler in ntdll.dll (see ntdll.S on ntoskrnl for info)
It also provides exports for legacy SFU 3.5, altrough it might not be 1:1 compatible?

### csrss.exe/psxsrv.dll/psxss.exe
I haven't finished checking if this can be correctly done, but the idea is to keep use csrss.exe to register a custom userland server for POSIX, like the original csrss.exe does with basesrv.dll or if we completely need a new psxss.
