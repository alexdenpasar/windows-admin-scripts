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

REM Установка основного пути
set basepath=Z:\ftp\Mikrotik

REM Проверка существования базовой папки
if not exist "%basepath%" (
    echo ОШИБКА: Базовая папка %basepath% не существует!
    echo Создание базовой папки...
    mkdir "%basepath%"
    if errorlevel 1 (
        echo ОШИБКА: Не удалось создать базовую папку!
        pause
        exit /b 1
    )
    echo Базовая папка создана успешно.
)

REM Проверка существования папки с текущей датой
set todayfolder=%basepath%\%curdate%
if not exist "%todayfolder%" (
    echo Создание папки для сегодняшней даты: %curdate%
    mkdir "%todayfolder%"
    if errorlevel 1 (
        echo ОШИБКА: Не удалось создать папку %todayfolder%!
        pause
        exit /b 1
    )
    echo Папка %curdate% создана успешно.
) else (
    echo Папка для сегодняшней даты уже существует: %curdate%
)

REM Удаление старых папок (старше 30 дней)
echo.
echo Поиск папок для удаления (старше 30 дней)...

REM Проверяем наличие папок для удаления
forfiles /p "%basepath%" /m ???????? /d -30 >nul 2>&1
if errorlevel 1 (
    echo Папки для удаления не найдены.
) else (
    echo Найдены папки для удаления:
    
    REM Показываем какие папки будут удалены
    forfiles /p "%basepath%" /m ???????? /d -30 /C "cmd /c echo Будет удалена: @file (@fdate)"
    
    echo.
    set /p confirm="Продолжить удаление? (Y/N): "
    if /i "%confirm%"=="Y" (
        echo Удаление старых папок...
        forfiles /p "%basepath%" /m ???????? /d -30 /C "cmd /c if exist @path (echo Удаляется: @file && rmdir /s /q @path)"
        echo Удаление завершено.
    ) else (
        echo Удаление отменено пользователем.
    )
)

echo.
echo Скрипт завершен.
REM Убираем exit для возможности просмотра результатов
pause