;Include file for error code definitions
;=====Major error codes=====
eMemory     = 00h
eLink		= 01h
eRuntime    = 02h

;=====Minor error codes=====
eMinor_Undef    = 00h
;==eMemory==
eMem_OutOfStack = 01h
eMem_NoSuchVar  = 02h
eMem_Allocation = 03h
eMem_OutOfRAM   = 04h
;==eLink==
eLink_Timeout	= 01h
eLink_Generic	= 02h
;==eRuntime
eRuntime_BadVersion     = 01h
eRuntime_Unimplemented  = 02h
eRuntime_BadType        = 03h