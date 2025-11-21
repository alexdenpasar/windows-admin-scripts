# Scripts Collection / Коллекция скриптов

[English](#english) | [Русский](#russian)

---

<a name="english"></a>

# Scripts Collection

A collection of scripts for automating Windows environment administration processes.

## 📋 Table of Contents

- [Network Scripts](#network-scripts)
- [Backup Scripts](#backup-scripts)
- [Exchange Server](#exchange-server)
- [Disk Management](#disk-management)
- [Utility Scripts](#utility-scripts)

---

## 🌐 Network Scripts

### AddRouteToKi.ps1
VPN connection configuration with split tunneling.

**Features:**
- Enable split tunneling for VPN connection
- Add static route to network behind VPN (192.168.1.0/24)
- Disable use of VPN gateway as default gateway

**Usage:**
```powershell
.\AddRouteToKi.ps1
```

**Note:** Change "VPN-Name" to your VPN connection name.

---

## 💾 Backup Scripts

### BackupDatabases1C.bat
Comprehensive backup solution for 1C file databases.

**Key Features:**
- Automatic copying of database files (.1CD)
- WinRAR archiving
- Log rotation
- Archive transfer to remote server
- Email notifications of results

**Process Structure:**
1. Copy databases from `D:\Base1C` to `D:\dumpBase1C`
2. Remove service files (.cfl, .dat, .bin, .ind, .log, .lgd)
3. Create archive in `D:\DumpArh1C`
4. Transfer to `\\srv-backup\folder`
5. Send notification

**Requirements:**
- WinRAR installed in `C:\Program Files\WinRAR\`
- Access to network storage `\\srv-backup\folder`
- Configured SMTP server

### VeeamBackup.ps1
Automated backup of virtual machines via Veeam Backup Free Edition.

**Features:**
- Backup virtual machines from vCenter/ESXi
- Automatic deletion of backups older than 14 days
- Create daily folders with date stamps
- Compression and optional encryption
- Email reports with HTML formatting
- Automatic cleanup of corrupted backups

**Configuration:**
```powershell
# Main parameters at the beginning of the script:
$VMNames = "srv-dc-01", "srv-dc-02", "srv-dc-03"  # VM list
$HostName = "192.168.0.10"                        # vCenter/ESXi
$Directory = "D:\"                                 # Backup directory
$CompressionLevel = "5"                           # Compression level (0-9)
$Retention = "Never"                              # Retention period
```

**Email Notifications:**
```powershell
$SMTPServer = "smtp.server.com"
$EmailFrom = "veeam@server.com"
$EmailTo = "user@server.com"
```

---

## 📧 Email Scripts

### Email_Good_m.ps1
Send notification of successful backup.

### Email_bad_d.ps1
Send notification of backup failure.

**Parameters:**
- SMTP server
- Sender/recipient
- Subject and message body
- Automatic time insertion

---

## 📊 Exchange Server

### Disable_activesync_and_outlook_web_app.ps1
Remote disable ActiveSync and OWA for user via Kerberos authentication.

**Usage:**
```powershell
.\Disable_activesync_and_outlook_web_app.ps1 "username@example.com"
```

**Requirements:**
- Exchange administrator rights
- Kerberos authentication
- Specify Exchange server FQDN in `$ServerFQDN` variable

### Exchange Log Cleanup.ps1
Safe cleanup of Exchange Server transaction logs.

**Features:**
- Automatic detection of databases on server
- Check database status (Clean/Dirty Shutdown)
- Safe database dismount/mount
- Delete logs older than specified period
- Detailed operation logging

**Process:**
1. Get list of databases on current server
2. Dismount database
3. Check status via `eseutil /mh`
4. Delete old logs (only for Clean Shutdown)
5. Mount database back

**Configuration:**
```powershell
$LogRetentionDays = 7  # Log retention period
```

**⚠️ Important:** Script does NOT delete logs if database is in Dirty Shutdown state!

---

## 💿 Disk Management

### DirectorySizeReport.ps1
Analyze directory sizes on C:\ drive.

**Output:**
```
Folder              Size(GB)
------              --------
C:\Windows          25.43
C:\Program Files    15.67
C:\Users            8.92
```

### Get-LargeFiles.ps1
Find files larger than 1 GB on C:\ drive.

**Output:**
```
FullName                          Size(GB)
--------                          --------
C:\pagefile.sys                   16.00
C:\Users\User\backup.vhdx         12.50
```

### Check-SystemVolumeSize.ps1
Check System Volume Information folder size.

**Use Case:** Diagnose disk space issues, analyze restore point sizes.

---

## 🛠️ Utility Scripts

### Set_and_Remove_Folder.bat
Automatic creation of daily folders and deletion of old ones (older than 30 days).

**Features:**
- Create folder with name in `YYYYMMDD` format
- Automatic deletion of folders older than 30 days
- Detailed logging of all operations
- Check existence of base directory

**Configuration:**
```batch
set lifetime=30              # Retention period in days
set basepath=D:\Folder      # Base directory
```

**Usage:** Windows Task Scheduler for daily execution.

### PassResetKerberos.bat
Reset computer account password for domain controllers.

**Use Cases:**
- Restore trust relationships in domain
- Resolve Kerberos authentication issues
- Bulk password reset for multiple DCs

**Usage:**
```batch
PassResetKerberos.bat
# Enter username with domain administrator rights
# Enter password
```

**⚠️ Warning:** Run only when experiencing DC authentication issues!

---

## 📋 Requirements

### General Requirements:
- Windows Server 2012 R2 or higher
- PowerShell 5.1 or higher
- Administrator rights

### Specific Requirements:

**For VeeamBackup.ps1:**
- Veeam Backup & Replication Free Edition 9.0+
- VMware vCenter/ESXi

**For Exchange Scripts:**
- Exchange Server 2013/2016/2019
- Exchange Management Shell

**For BackupDatabases1C.bat:**
- WinRAR
- 1C:Enterprise 8.x

---

## ⚙️ Installation and Setup

1. Clone the repository:
```bash
git clone <repository-url>
```

2. Configure parameters in scripts for your infrastructure:
   - Directory paths
   - Email addresses and SMTP servers
   - Server names and network paths

3. Create tasks in Windows Task Scheduler for automatic execution

---

## 📝 License

These scripts are provided "as is" without any warranties. Use at your own risk.

---

## ⚠️ Important Notes

- **Always test scripts in a test environment** before using in production
- Regularly check logs for errors
- Configure monitoring of email notifications
- Keep backup copies of configurations
- Document all changes in scripts

---

<a name="russian"></a>

# Коллекция скриптов

Коллекция скриптов для автоматизации процессов администрирования в Windows-среде.

## 📋 Содержание

- [Сетевые скрипты](#сетевые-скрипты)
- [Резервное копирование](#резервное-копирование)
- [Exchange Server](#exchange-server-ru)
- [Управление дисками](#управление-дисками)
- [Служебные скрипты](#служебные-скрипты)

---

## 🌐 Сетевые скрипты

### AddRouteToKi.ps1
Конфигурация VPN-подключения с раздельным туннелированием.

**Функционал:**
- Включение split tunneling для VPN-соединения
- Добавление статического маршрута к сети за VPN (192.168.1.0/24)
- Отключение использования VPN-шлюза по умолчанию

**Использование:**
```powershell
.\AddRouteToKi.ps1
```

**Примечание:** Требуется изменить "VPN-Name" на имя вашего VPN-подключения.

---

## 💾 Резервное копирование

### BackupDatabases1C.bat
Комплексное решение для резервного копирования файловых баз данных 1C.

**Основные возможности:**
- Автоматическое копирование файлов баз данных (.1CD)
- Архивирование с использованием WinRAR
- Ротация логов
- Перенос архивов на удаленный сервер
- Email-уведомления о результатах

**Структура процесса:**
1. Копирование баз из `D:\Base1C` в `D:\dumpBase1C`
2. Удаление служебных файлов (.cfl, .dat, .bin, .ind, .log, .lgd)
3. Создание архива в `D:\DumpArh1C`
4. Перенос на `\\srv-backup\folder`
5. Отправка уведомления

**Требования:**
- WinRAR установлен в `C:\Program Files\WinRAR\`
- Доступ к сетевому хранилищу `\\srv-backup\folder`
- Настроенный SMTP-сервер

### VeeamBackup.ps1
Автоматизация резервного копирования виртуальных машин через Veeam Backup Free Edition.

**Функционал:**
- Backup виртуальных машин из vCenter/ESXi
- Автоматическое удаление бэкапов старше 14 дней
- Создание ежедневных папок с датой
- Сжатие и опциональное шифрование
- Email-отчеты с HTML-форматированием
- Автоматическая очистка поврежденных бэкапов

**Настройка:**
```powershell
# Основные параметры в начале скрипта:
$VMNames = "srv-dc-01", "srv-dc-02", "srv-dc-03"  # Список ВМ
$HostName = "192.168.0.10"                        # vCenter/ESXi
$Directory = "D:\"                                 # Директория бэкапов
$CompressionLevel = "5"                           # Уровень сжатия (0-9)
$Retention = "Never"                              # Срок хранения
```

**Email-уведомления:**
```powershell
$SMTPServer = "smtp.server.com"
$EmailFrom = "veeam@server.com"
$EmailTo = "user@server.com"
```

---

## 📧 Email-скрипты

### Email_Good_m.ps1
Отправка уведомления об успешном резервном копировании.

### Email_bad_d.ps1
Отправка уведомления об ошибке резервного копирования.

**Параметры:**
- SMTP-сервер
- Отправитель/получатель
- Тема и текст сообщения
- Автоматическая подстановка времени

---

## 📊 Exchange Server {#exchange-server-ru}

### Disable_activesync_and_outlook_web_app.ps1
Удаленное отключение ActiveSync и OWA для пользователя через Kerberos-аутентификацию.

**Использование:**
```powershell
.\Disable_activesync_and_outlook_web_app.ps1 "username@example.com"
```

**Требования:**
- Права администратора Exchange
- Kerberos-аутентификация
- Указать FQDN сервера Exchange в переменной `$ServerFQDN`

### Exchange Log Cleanup.ps1
Безопасная очистка логов транзакций Exchange Server.

**Возможности:**
- Автоматическое определение баз данных на сервере
- Проверка статуса баз (Clean/Dirty Shutdown)
- Безопасное отключение/подключение баз
- Удаление логов старше заданного периода
- Детальное логирование операций

**Процесс работы:**
1. Получение списка баз данных на текущем сервере
2. Отключение базы данных
3. Проверка статуса через `eseutil /mh`
4. Удаление старых логов (только для Clean Shutdown)
5. Монтирование базы обратно

**Настройка:**
```powershell
$LogRetentionDays = 7  # Период хранения логов
```

**⚠️ Важно:** Скрипт НЕ удаляет логи, если база в состоянии Dirty Shutdown!

---

## 💿 Управление дисками

### DirectorySizeReport.ps1
Анализ размеров директорий на диске C:\.

**Вывод:**
```
Folder              Size(GB)
------              --------
C:\Windows          25.43
C:\Program Files    15.67
C:\Users            8.92
```

### Get-LargeFiles.ps1
Поиск файлов размером более 1 ГБ на диске C:\.

**Вывод:**
```
FullName                          Size(GB)
--------                          --------
C:\pagefile.sys                   16.00
C:\Users\User\backup.vhdx         12.50
```

### Check-SystemVolumeSize.ps1
Проверка размера папки System Volume Information.

**Применение:** Диагностика проблем с местом на диске, анализ размера точек восстановления.

---

## 🛠️ Служебные скрипты

### Set_and_Remove_Folder.bat
Автоматическое создание ежедневных папок и удаление старых (старше 30 дней).

**Функционал:**
- Создание папки с именем в формате `YYYYMMDD`
- Автоматическое удаление папок старше 30 дней
- Детальное логирование всех операций
- Проверка существования базовой директории

**Настройка:**
```batch
set lifetime=30              # Срок хранения в днях
set basepath=D:\Folder      # Базовая директория
```

**Использование:** Планировщик задач Windows для ежедневного запуска.

### PassResetKerberos.bat
Сброс пароля компьютерного аккаунта контроллеров домена.

**Применение:**
- Восстановление доверительных отношений в домене
- Решение проблем с Kerberos-аутентификацией
- Массовый сброс паролей нескольких DC

**Использование:**
```batch
PassResetKerberos.bat
# Введите имя пользователя с правами администратора домена
# Введите пароль
```

**⚠️ Внимание:** Запускать только при наличии проблем с аутентификацией DC!

---

## 📋 Требования

### Общие требования:
- Windows Server 2012 R2 или выше
- PowerShell 5.1 или выше
- Права администратора

### Специфические требования:

**Для VeeamBackup.ps1:**
- Veeam Backup & Replication Free Edition 9.0+
- VMware vCenter/ESXi

**Для Exchange-скриптов:**
- Exchange Server 2013/2016/2019
- Exchange Management Shell

**Для BackupDatabases1C.bat:**
- WinRAR
- 1C:Enterprise 8.x

---

## ⚙️ Установка и настройка

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
```

2. Настройте параметры в скриптах под вашу инфраструктуру:
   - Пути к директориям
   - Email-адреса и SMTP-серверы
   - Имена серверов и сетевые пути

3. Создайте задачи в Планировщике задач Windows для автоматического выполнения

---

## 📝 Лицензия

Эти скрипты предоставляются "как есть" без каких-либо гарантий. Используйте на свой страх и риск.

---

## ⚠️ Важные примечания

- **Всегда тестируйте скрипты в тестовой среде** перед использованием в продакшене
- Регулярно проверяйте логи на наличие ошибок
- Настройте мониторинг email-уведомлений
- Храните резервные копии конфигураций
- Документируйте все изменения в скриптах