//
// Forces J-Link to program, even if flash contents already match data to be programmed
//
rx 100
exec SetSkipProgOnCRCMatch=0
//
// Download application into QSPI flash
//
