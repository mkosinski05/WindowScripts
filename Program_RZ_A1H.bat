@echo off
    setlocal enableextensions 

    set RawData1=TempData%random%.tmp
    set RawData2=TempData%random%.bin
    set progdir=user_application
    set toolsdir=tools

    set programmer="JLink.exe"

    goto :PROGRAMMER_SET
    if not exist "C:\Program Files\SEGGER\JLink_V490e\JLink.exe" goto :64BIT_HOST
    set programmer="C:\Program Files\SEGGER\JLink_V490e\JLink.exe"
    goto :PROGRAMMER_SET
:64BIT_HOST    
    set programmer="C:\Program Files (x86)\SEGGER\JLink_V490e\JLink.exe"
    goto :PROGRAMMER_SET

:PROGRAMMER_SET    
    rem Get numbered list of files
    dir /b "%progdir%\*.bin" | findstr /i /n ".bin" > %RawData1%

    rem We could use 0 as exitCode, 
    rem but to keep original behaviour
    rem lets count the number of files
    for /F "tokens=*" %%f in ('type %RawData1% ^| find /c /v "" ') do set /A ExitCode=%%f + 1

    if %ExitCode%==0 (
        echo No log files
        goto endProcess
    )

    
    rem show menu
    for /f "tokens=1-2 delims=:." %%a in (%RawData1%) do echo %%a. %%b
    echo %Exitcode%. To Quit.
    set UserChoice=%ExitCode%
    set /p UserChoice= Choose item number from menu (%UserChoice%):

    if "%UserChoice%"=="" goto :EOF
    if "%UserChoice%"=="%ExitCode%" goto CLEAN_UP

    rem Search indicated file in list
    set SelectedFile=
    for /f "tokens=2 delims=:" %%f in ('findstr /B "%UserChoice%:" %RawData1%') do set SelectedFile=%%f

    if "%SelectedFile%"=="" (
        echo Incorrect selection
        goto CLEAN_UP
    )

    if not exist %progdir%\%SelectedFile% (
        echo File deleted
       goto CLEAN_UP
    )

    echo Programming OPTIONS
    echo 1 = Program NOR user application.
    echo 2 = Program QSPI user application.
    echo 3 = Program MMC user application.
    echo 4 = Exit
    SET /P ProgrammerChoice=Choose options (1=NOR , 2=QSPI, 3=MMC or 4=Exit): 
    echo selected file %progdir%\%SelectedFile%

    if "%ProgrammerChoice%"=="1" goto :NOR_Prog
    if "%ProgrammerChoice%"=="2" goto :QSPI_Prog
    if "%ProgrammerChoice%"=="3" goto :MMC_Prog
    echo No programmer Selected
    goto :CLEAN_UP	

:NOR_Prog
    echo NOR Programmer
    copy /y %toolsdir%\LoadUserNORTemplate.Command LoadUser.Command
    echo loadbin %progdir%\%SelectedFile%,0x00020000>>LoadUser.Command
    echo exit >> LoadUser.Command
    %programmer% -speed 12000 -if JTAG -device R7S721001 -CommanderScript LoadUser.Command
    goto :CLEAN_UP

:QSPI_Prog
    echo QSPI Programmer
    echo Remove power (5V) to the board before continuing. 
    echo Set SW6 as instructed below:
    echo SW6-1 OFF, SW6-2 ON, SW6-3 OFF, SW6-4 ON, SW6-5 ON, SW6-6 ON
    echo Reconnect power (5V) to the board before continuing. 
    pause
    echo ENSURE YOU HAVE RECONFIGURED THE SW6 SWITCHES ON THE TARGET
    echo - IT IS IMPORTANT -
    pause
    copy /y %toolsdir%\LoadUserQSPITemplate.Command LoadUser.Command
    echo loadbin %progdir%\%SelectedFile%,0x18080000>>LoadUser.Command
    echo exit >> LoadUser.Command
    %programmer% -speed 12000 -if JTAG -device R7S721001_DualSPI -CommanderScript LoadUser.Command
    goto :CLEAN_UP

:MMC_Prog
    echo MMC Programmer

    setlocal
    set file=%progdir%\%SelectedFile%
    FOR /F "usebackq" %%A IN ('%file%') DO set size=%%~zA
    echo file %1 size %size% bytes
    echo %size% > %RawData2%
    copy /y %toolsdir%\LoadUserNORTemplate.Command LoadUser.Command
    echo loadbin %progdir%\%SelectedFile%,0x00100000>>LoadUser.Command
    echo loadbin %toolsdir%\RZ_A1H_NOR_INIT_RSK.bin,0x00000000>>LoadUser.Command
    echo loadbin %toolsdir%\RZ_A1H_eMMC_Writer_RSK.bin,0x00020000>>LoadUser.Command
    echo exit >> LoadUser.Command
       
    %programmer% -speed 12000 -if JTAG -device R7S721001 -CommanderScript LoadUser.Command

    del /q %RawData2%
    goto :CLEAN_UP

:CLEAN_UP
    del /q *.tmp
    if exist LoadUser.Command  del /q LoadUser.Command   
    pause