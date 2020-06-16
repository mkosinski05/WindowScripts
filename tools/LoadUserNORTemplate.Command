rx 3
//
// Specify CFI area in DLL 
//
h

exec setcfiflash 0x00000000-0x00FFFFFF
exec setworkram 0x20090000-0x200FFFFF
//
// !!!!!!!!!!!! Only for testing purposes to demonstrate flash download speed via J-Link Commander, do *not* take over into e2 studio !!!!!!!!!!!!!
// Forces J-Link to program, even if flash contents already match data to be programmed
//
exec SetSkipProgOnCRCMatch=0
//
// Make sure that P7_0 (CS), P7_6 (WE), P7_8 (RD) are set as alternate function
// PMC (off 0x420): Configure PIOs as alternate function
// PFCAE (off 0xA20): Alternate function 0
// PFCE (off 0x620): Alternate function 0
// PFC (off 0x520): Alternate function 0
// PIPC (off 0x7220): I/O is controlled by alternate function
//
w2 0xFCFE341C,0xFF41
w2 0xFCFE3A1C,0x0000
w2 0xFCFE361C,0x0000
w2 0xFCFE351C,0x0000
w2 0xFCFE721C,0xFF41
//
// Make sure that P8_13-15 (A21-23) are set as alternate function
//
// PMC (off 0x420): Configure PIOs as alternate function
// PFCAE (off 0xA20): Alternate function 0
// PFCE (off 0x620): Alternate function 0
// PFC (off 0x520): Alternate function 0
// PIPC (off 0x7220): I/O is controlled by alternate function
//
w2 0xFCFE3420,0xFFFF
w2 0xFCFE3A20,0x0000
w2 0xFCFE3620,0x0000
w2 0xFCFE3520,0x0000
w2 0xFCFE7220,0xFFFF
//
// Make sure that P9_0 (A24), P9_1 (A25) are set as alternate function
// PMC (off 0x420): Configure PIOs as alternate function
// PFCAE (off 0xA20): Alternate function 0
// PFCE (off 0x620): Alternate function 0
// PFC (off 0x520): Alternate function 0
// PIPC (off 0x7220): I/O is controlled by alternate function
//
w2 0xFCFE3424,0x0003
w2 0xFCFE3A24,0x0000
w2 0xFCFE3624,0x0000
w2 0xFCFE3524,0x0000
w2 0xFCFE7224,0x0003
//
// Download application into CFI NOR flash
