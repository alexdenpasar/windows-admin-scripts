@echo off
chcp 1251
set /p time="Компьютер выключить через (в часах): "
set /a sumtime=%time%*3600
setlocal
cls
for /l %%i in (%sumtime%,-1,0) do (

    echo.
    echo.
    echo Отключение ПК через:   %%i
    echo.     
    1>nul ping -n 2 127.1
    cls    

)
shutdown -s -t 1
