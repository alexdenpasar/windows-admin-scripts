@ECHO OFF

title Resetting the Windows Server Domain Controller Computer Account Password

set /p user="Enter username: "
set /p password="Enter user password: "

for %%i in (dcserver01 dcserver02 dcserver6 dcserver dcserver2 dcserver3) do (

echo Clearing %user% user credentials with %%i Server 

netdom resetpwd /s:%%i /ud:%user% /pd:%password%

)

pause
::exit