@echo off & setLocal EnableDelayedExpansion
@REM This file is to be used with the Task Scheduler
@REM After launching it will pick a random number of minutes (default 5-30) and shut the computer down
@REM to stop a scheduled shutdown run: shutdown /a
goto :init

:usage
    echo Useage: .\random_shutdown.bat [--help] [--alert] [--min ^<minimum minutes to shutdown^>] [--min ^<maximum minutes to shutdown^>]
    goto:EOF

:init
    SET do_alert=false
    SET min_time=5
    SET max_time=30
    goto parse

:parse
    SET param=%~1
    SET arg=%~2
    if "%param%" == "--alert" (
        shift
        SET do_alert=true
    ) else if "%param%" == "--min" (
        shift
        if not "%arg%" == "" (
            SET min_time="%arg%"
            shift
        ) else (
            echo Unrecognized option %1. 1>&2
            echo:
            goto usage
        )
    ) else if "%param%" == "--max" (
        shift
        if not "%arg%" == "" (
            SET max_time="%arg%"
            shift
        ) else (
            echo Unrecognized option %1. 1>&2
            echo:
            goto usage
        )
    ) else if "%param%" == "--help" (
        goto usage
    ) else if "%param%" == "" (
        goto run
    ) else (
        echo Unrecognized option %1. 1>&2
        echo:
        goto usage
    )
    goto parse

:run
    @REM create a random time to shutdown
    call:random_shutdown_time %min_time% %max_time%

    @REM schedule the shutdown
    shutdown -s -t %time_to_die_seconds%

    @REM TODO: Deal with the timer here and send multiple warnings
    @REM alert the user
    if %do_alert% == true powershell "(new-object -COM WScript.Shell).popup('shutdown in %time_to_die_minutes%',0,'Go the fuck to sleep.')"
    goto:EOF

:random_shutdown_time
    @REM random_shutdown_time()
    @REM Input: %1 is min, %2 is max.
    @REM Output:    time_to_die_minutes is set to a random number from min through max, can be used to display a human readable 'minutes to shutdown'.
    @REM            time_to_die_seconds is the minutes to shutdown in a in a shutdown command friendly seconds format
    @REM TODO: add some min max sanitising
    SET /A time_to_die_minutes=(!random!) %% ((%2) + 1 - %1) + (%1)
    SET /A time_to_die_seconds= %time_to_die_minutes * 60
    goto:EOF
