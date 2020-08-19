r
h

exec device = R7S921053VCBG

loadbin ..\..\Renesas\RZ_A2M_BOOTLOADER\Precompiled\rza2_qspi_flash_ddr_bootloader.bin,0x20000000
verifybin ..\..\Renesas\RZ_A2M_BOOTLOADER\Precompiled\rza2_qspi_flash_ddr_bootloader.bin,0x20000000

r
g
q
