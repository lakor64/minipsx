/*
 * COPYRIGHT:       See COPYING in the top level directory
 * PROJECT:         Linux/POSIX compatibility layer
 * FILE:            psx/process.h
 * PURPOSE:         POSIX Context definition
 * PROGRAMMERS:     Christian Rendina (christian.rendina@gmail.com)
 */
#pragma once

#define MAX_PROCESS_FD 4096

typedef struct _PSXFD
{
	HANDLE NtHandle;
	//UNICODE_STRING NtFileName;
	//UTF8_STRING PsxFileNane;
} PSXFD, *PPSXFD;

/*
	Context of a POSIX thread
	
	ReactOS: ETHREAD->PicoThread
	MiniROS: ETHREAD->Tcb->Win32Thread
*/
typedef struct _PSXTHREADINFO
{
	PETHREAD peThread; /* should not exist on a PicoThread */
	LONG RefCount;
	/*--------------------------------------------------------*/
	struct _PSXPROCESSINFO* ppi;
	errno_t ThreadError;

} PSXTHREADINFO, *PPSXTHREADINFO;

/*
	Context of a POSIX process
	
	ReactOS: EPROCESS->PicoContext
	MiniROS: EPROCESS->W32Process
	
	NOTE: DOES NOT MATCH WSL!!!
*/
typedef struct _PSXPROCESSINFO
{
	PEPROCESS peProcess; /* should not exist on a PicoThread */
	LONG RefCount;
	/*--------------------------------------------------------*/
	long OpenedFD;
	PPSXFD Files[MAX_PROCESS_FD];
} PSXPROCESSINFO, *PPSXPROCESSINFO;
