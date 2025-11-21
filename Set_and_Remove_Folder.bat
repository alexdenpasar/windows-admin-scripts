@Echo OFF
REM Установка кодировки для корректного отображения русского текста
chcp 1251 >nul

REM Получение текущей даты и времени
set day=%DATE:~0,2%
set month=%DATE:~3,2%
set year=%DATE:~6,4%
set h=%TIME:~0,2%
set m=%TIME:~3,2%
set s=%TIME:~6,2%
set curtime=%h%-%m%-%s%
set curdate=%year%%month%%day%
set FILELOG="C:\scripts\logs\logs_%curdate%%h%%m%%s%.txt"

REM Время жизни папки в днях
set lifetime=30

REM Установка основного пути
set basepath=D:\Folder

echo Старт работы скрипта. Время %year%-%month%-%day% %h%:%m%:%s%. > %FILELOG%

REM Проверка существования базовой папки
if not exist "%basepath%" (
    echo ОШИБКА: Базовая папка %basepath% не существует! >> %FILELOG%
    echo Создание базовой папки... >> %FILELOG%
    mkdir "%basepath%"
    if errorlevel 1 (
        echo ОШИБКА: Не удалось создать базовую папку! >> %FILELOG%
        pause
        exit /b 1
    )
    echo Базовая папка создана успешно. >> %FILELOG%
)

REM Проверка существования папки с текущей датой
set todayfolder=%basepath%\%curdate%
if not exist "%todayfolder%" (
    echo Создание папки для сегодняшней даты: %curdate% >> %FILELOG%
    mkdir "%todayfolder%"
    if errorlevel 1 (
        echo ОШИБКА: Не удалось создать папку %todayfolder%! >> %FILELOG%
        pause
        exit /b 1
    )
    echo Папка %curdate% создана успешно. >> %FILELOG%
) else (
    echo Папка для сегодняшней даты уже существует: %curdate% >> %FILELOG%
)

REM Удаление старых папок (старше 30 дней)
echo. >> %FILELOG%
echo Поиск папок для удаления (старше %lifetime% дней)... >> %FILELOG%

REM Проверяем наличие папок для удаления
forfiles /p "%basepath%" /m ???????? /d -%lifetime% >nul 2>&1
if errorlevel 1 (
    echo Папки для удаления не найдены. >> %FILELOG%
) else (
    echo Найдены папки для удаления: >> %FILELOG%
    
    REM Показываем какие папки будут удалены
    forfiles /p "%basepath%" /m ???????? /d -%lifetime% /C "cmd /c echo Будет удалена: @file (@fdate)" >> %FILELOG%
    
    echo. >> %FILELOG%
	echo Удаление старых папок... >> %FILELOG%
	forfiles /p "%basepath%" /m ???????? /d -%lifetime% /C "cmd /c if exist @path (echo Удаляется: @file && rmdir /s /q @path)"
	echo Старая папка %basepath% удалена!
	echo Удаление завершено. >> %FILELOG%
)

echo. >> %FILELOG%
echo Скрипт завершен. >> %FILELOG%
REM Убираем exit для возможности просмотра результатов
exit
