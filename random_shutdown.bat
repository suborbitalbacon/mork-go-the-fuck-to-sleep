@echo off & setLocal EnableDelayedExpansion
@REM This file is to be used with the Task Scheduler
@REM After launching it will pick a random number of minutes (5-30) and shut the computer down

@REM create a random time to shutdown
@REM TODO: make min and max arguments
call:random_shutdown_time 5 30
@REM alert the user
@REM TODO: make the alert optional through an argument
powershell "(new-object -COM WScript.Shell).popup('shutdown in %time_to_die_minutes%',0,'Go the fuck to sleep.')"
@REM schedule the shutdown
shutdown -s -t %time_to_die_seconds%
@REM TODO: Deal with the timer here and send multiple warnings

goto:EOF
@REM random_shutdown_time()
@REM Input: %1 is min, %2 is max.
@REM Output:    time_to_die_minutes is set to a random number from min through max, can be used to display a human readable 'minutes to shutdown'.
@REM            time_to_die_seconds is the minutes to shutdown in a in a shutdown command friendly seconds format
:random_shutdown_time
SET /A time_to_die_minutes=(!random!) %% ((%2) + 1 - %1) + (%1)
SET /A time_to_die_seconds= %time_to_die_minutes * 60
goto:EOF