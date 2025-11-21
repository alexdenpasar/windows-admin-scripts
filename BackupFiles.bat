@Echo OFF
chcp 1251
set logfile=C:\_script\BackupBase1C\log.txt
Echo Start backup bases 1C >> %logfile%
:: Clear Log file
mkdir C:\_script\BackupBase1C\LogArh

set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set curtime=%h%-%m%-%s%
set curdate=%day%-%month%-%year%
set curdatetime=%curdate%_%curtime%
set d=C:\_script\BackupBase1C
set app="C:\Program Files\WinRAR\WinRAR.exe"
set ar="C:\_script\BackupBase1C\LogArh\Log_%curdatetime%.rar"
set s=###########################
set h=!!Log file backup database 1C!!

set l="C:\_script\BackupBase1C\log.txt"
set f=log.txt
pushd "%d%" & call:size "%f%"
:size
if %~z1 geq  500000 (%app% a -r -m5 %ar%  %l% & del %l% & echo %s%%h%%s%  > %l%) else (echo Size file OK)
:: End Clear Log File
:: Copying 1C database files (.1CD) to the dump folder for backup to the archive!
SetLocal EnableDelayedExpansion
set day=%DATE:~0,2%
	set month=%DATE:~3,2%
	set year=%DATE:~6,4%
	set h=%TIME:~0,2%
	set m=%TIME:~3,2%
	set s=%TIME:~6,2%
	set curtime=%h%:%m%:%s%
	set curdate=%day%.%month%.%year%
	set curdatetime=%curdate%-%curtime%
:: Файл логирования
set logfile=C:\_script\BackupBase1C\log.txt
:: Проверка на существование папки
If Exist "%Papka%\*.*" (Echo %curdatetime%: Folder dumpBase1C successfully created! >> %logfile%) 
if not exist "%Papka%\*.*" (Echo %curdatetime%: Error creating dumpBase1C folder... >> %logfile%) 
mkdir D:\dumpBase1C
mkdir D:\DumpArh1C
:: Проверочные файлы
set f1=1Cv8.1CD
:: Устанавливаем корневую папку
set DataRoot=D:\Base1C
:: Временная папка для копирования
set Papka=D:\dumpBase1C
:: Получаем структуру вложенных папок
For /F "delims=" %%A In ('Dir "%DataRoot%\" /B /AD') Do (
	Set RelativePath=%%A
	:: Получение относительного пути из полного
	Set RelativePath=!RelativePath:%DataRoot%=!
	:: Получение даты
	set day=%DATE:~0,2%
	set month=%DATE:~3,2%
	set year=%DATE:~6,4%
	set h=%TIME:~0,2%
	set m=%TIME:~3,2%
	set s=%TIME:~6,2%
	set curtime=%h%:%m%:%s%
	set curdate=%day%-%month%-%year%
	set curdatetime=%curdate%-%curtime%
	:: Копирование бд во временную папку
	xcopy "%DataRoot%\%%A" "%Papka%\%%A\" /S /E /Y /C /Z
	::for /f "delims=" %%a in ('dir /b /s /a-d "путь\*" 2^>nul') do if /i not "%%~xa"==".1CD" del /q "%%a"
	del /S /F /Q D:\dumpBase1C\*.cfl
	del /S /F /Q D:\dumpBase1C\*.dat
	del /S /F /Q D:\dumpBase1C\*.bin
	del /S /F /Q D:\dumpBase1C\*.ind
	del /S /F /Q D:\dumpBase1C\*.log
	del /S /F /Q D:\dumpBase1C\*.lgd
	:: Проверка файлов и логирование
	If exist "%Papka%\!RelativePath!\%f1%" ( Echo %curdatetime%: Base %%A: File %f1% copied successfully >> %logfile%)
	if not exist "%Papka%\!RelativePath!\%f1%" ( Echo %curdatetime%: ***Base %%A: Error copying file %f1%...*** >> %logfile%) 
	if exist "%Papka%\!RelativePath!\%f1%"  ( echo %curdatetime%: Base %%A copied successfully.  >> %logfile%)
	if not exist "%Papka%\!RelativePath!\*.*" ( Echo %curdatetime%: ***Error copying database %%A...*** >> %logfile%) 
)
:: End copying databases

:: Starting backup to the archive!
set now=%TIME:~0,-3%
set now=%now::=%
set now=%now: =0%
set now=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%now%

rem объявляем переменные для удобства
rem путь до архиватора
set rar_path="C:\Program Files\WinRAR\WinRAR.exe"
rem где хранить архив
set back_path="D:\DumpArh1C\"
rem формат имени архива
set arh_fname=BackupBase1C_full -ag_YYYY_MM_DD
rem Расположение файла-списка того что архивируем
set include_list=@C:\_script\BackupBase1C\listbackup.txt
rem Расположение файла-списка исключений
rem set exclude_list=-x@C:\_script\BackupBase1C\listnoback.txt
rem Аргументы архивирования
set rar_argum=-m5

rem очищаем временное хранилище файлов
rem D:\script\clearfolder.bat

rem Удаляем предыдущий бэкап через предыдущий, так чтобы хранилось только 2 полных
rem forfiles.exe /p %back_path% /s /m *.rar /d -13 /c "cmd /c del /q /f @file" 

rem Архивируем
%rar_path% a %back_path%%arh_fname% %include_list% %exclude_list% %rar_argum% 
:: Ending backup to the archive!
:: Starting delete dump folder!
set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set curtime=%h%:%m%:%s%
set curdate=%day%-%month%-%year%
set curdatetime=%curdate% %curtime%
rmdir /s /q D:\dumpBase1C\
chcp 1251
set Papka=D:\dumpBase1C\
set logfile=C:\_script\BackupBase1C\log.txt
If Exist "%Papka%\*.*" (Echo %curdatetime%: Error deleting a folder dumpBase1C >> %logfile%)
If not Exist "%Papka%\*.*" (Echo %curdatetime%: Successfully deleting a folder dumpBase1C >> %logfile%)
:: Ending delete dump folder!
:: Move backup on Backup-Server
move D:\DumpArh1C\BackupBase1C_full_%year%_%month%_%day%.rar \\srv-backup\folder

:: Check alarm!
set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%
set curdate=%day%.%month%.%year%
set curdatetime=%curdate%

if exist \\srv-backup\folder\BackupBase1C_full_%year%_%month%_%day%.rar (
PowerShell.exe -File C:\_script\BackupBase1C\Email_Good_m.ps1
exit
) else (
PowerShell.exe -File C:\_script\BackupBase1C\Email_bad_d.ps1)
:: Ending alarm
::rmdir /s /q D:\DumpArh1C
exit
