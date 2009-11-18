;Include file for error code definitions
;=====Major error codes=====
eMemory     = 00h
eLink		= 01h

;=====Minor error codes=====
eMinor_Undef    = 00h
;==eMemory==
eMem_OutOfStack = 01h
eMem_NoSuchVar  = 02h
;==eLink==
eLink_Timeout	= 01h
eLink_Generic	= 02h