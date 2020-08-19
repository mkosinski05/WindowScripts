r
h

exec device = R7S921053VCBG

loadbin ..\..\Renesas\RZ_A2M_BOOTLOADER\Precompiled\rza2m_hyperflash_boot2_loader_gcc.bin,0x30000000
verifybin ..\..\Renesas\RZ_A2M_BOOTLOADER\Precompiled\rza2m_hyperflash_boot2_loader_gcc.bin,0x30000000

r
g
q
