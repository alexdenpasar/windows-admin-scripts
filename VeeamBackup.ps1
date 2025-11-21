##################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
##################################################################
#                Удаление бэкапов старше 14 дней                 #
##################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
##################################################################
Param (
#период в днях старше которого файл считается пригодным к удалению
[int]$Period = 14 , 
#каталог для просмотра  
[String]$PATH = "D:\" ,    
#включать ли вложенные каталоги
[bool]$recurse = $true
)
filter Get-OldFiles{
    Param (
    [int]$Period = 14
    )
    if(   
    ([DateTime]::Now.Subtract($_.CreationTime)).Days -gt $Period
    ) 
    {return $_ }
}
if ($recurse) 
{dir -path $PATH -recurse  | Get-OldFiles -Period $Period | Remove-Item -recurse -force}
else
{dir -path $PATH | Get-OldFiles -Period $Period | Remove-Item -force}

##################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
##################################################################
#                         Бэкап ВМ                               #
##################################################################
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#
##################################################################

##################################################################
#                Путь к сетевому хранилищу
##################################################################
$dir1 = "D:\"
##################################################################
#                Создание папки для хранения бэкапов
#################################################################
$data = Get-Date -format "yyyy-MM-dd"
if (Test-Path $dir1\$data)
    {
        "Папка уже существует!!!"
    }
else
    {
        New-Item -Path "$dir1\$data" -ItemType "directory"
    }
##################################################################
#                  Переменные
##################################################################

# Названия ВМ(Пример: "VM1", "VM2"):
$VMNames = "srv-dc-01", 
"srv-dc-02",
"srv-dc-03"


# Имя или ip vCenter:
$HostName = "192.168.0.10"

# Директория бэкапа (Пример C:\Backup):
#$Directory = "C:\Backup"
$Directory = "D:\"


# Степень сжатия (Optional; Possible values: 0 - None, 4 - Dedupe-friendly, 5 - Optimal, 6 - High, 9 - Extreme) 
$CompressionLevel = "5"

# Гостевая ОС (Possible values: $True/$False):
$EnableQuiescence = $False

# Шифрование (Optional; $True/$False)
$EnableEncryption = $False

# Ключ шифрования (Optional; path to a secure string)
$EncryptionKey = ""

# Время, через которое удаляется бекап (Possible values: Never , Tonight, TomorrowNight, In3days, In1Week, In2Weeks, In1Month)
$Retention = "Never"

##################################################################
#                   Настройка уведомления
##################################################################

# Включение уведомления (Optional)
$EnableNotification = $True

# Email SMTP server
$SMTPServer = "smtp.server.com"

# Email FROM
$EmailFrom = "veeam@server.com" 

# Email TO
$EmailTo = "user@server.com"

# Email subject
$EmailSubject = "Veeam-Backup Finish"

#Login and Password
$Username = "username"
$Password = "password"

##################################################################
#                   Формат письма
##################################################################

$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"

##################################################################
#                  Конечные переменные
##################################################################

Asnp VeeamPSSnapin

$Server = Get-VBRServer -name $HostName
$MesssagyBody = @()

foreach ($VMName in $VMNames)
{
  $VM = Find-VBRViEntity -Name $VMName -Server $Server
  
  If ($EnableEncryption)
  {
    $EncryptionKey = Add-VBREncryptionKey -Password (cat $EncryptionKey | ConvertTo-SecureString)
    $ZIPSession = Start-VBRZip -Entity $VM -Folder $Directory -Compression $CompressionLevel -DisableQuiesce:(!$EnableQuiescence) -AutoDelete $Retention -EncryptionKey $EncryptionKey
  }
  
  Else 
  {
    $ZIPSession = Start-VBRZip -Entity $VM -Folder $Directory -Compression $CompressionLevel -DisableQuiesce:(!$EnableQuiescence) -AutoDelete $Retention
  }
  
  If ($EnableNotification) 
  {
    $TaskSessions = $ZIPSession.GetTaskSessions().logger.getlog().updatedrecords
    $FailedSessions =  $TaskSessions | where {$_.status -eq "EWarning" -or $_.Status -eq "EFailed"}
  
  if ($FailedSessions -ne $Null)
  {
    $MesssagyBody = $MesssagyBody + ($ZIPSession | Select-Object @{n="Name";e={($_.name).Substring(0, $_.name.LastIndexOf("("))}} ,@{n="Start Time";e={$_.CreationTime}},@{n="End Time";e={$_.EndTime}},Result,@{n="Details";e={$FailedSessions.Title}})
  }
   
  Else
  {
    $MesssagyBody = $MesssagyBody + ($ZIPSession | Select-Object @{n="Name";e={($_.name).Substring(0, $_.name.LastIndexOf("("))}} ,@{n="Start Time";e={$_.CreationTime}},@{n="End Time";e={$_.EndTime}},Result,@{n="Details";e={($TaskSessions | sort creationtime -Descending | select -first 1).Title}})
  }
  
  }
##################################################################
#         Условия проверки на перемещение и удаление!!!!!!       #
##################################################################
     
  if ($FailedSessions -ne $Null)
    {
	"Удаление поврежденного бэкапа..."
        $file2 = Get-Item $dir1\*$VMName*.vbk
        Remove-Item -Path $file2 #удаление поврежденного файла
        "Готово!"
    }
  else
    {    	 
            #Перемещение нового файла
        if($file2 = get-childitem $dir1\* -include *$VMName$data*.vbk -recurse)
            {
		"Перемещаю бэкап в папку..."
                Move-Item -Path $file2 -Destination $dir1\$data\
		"Готово!"
            } 	
        else
            {
                "Новый Бэкап не найден!"
            }
    }

}
# Удаление пустого каталога
$Folders_NULL = Get-ChildItem "D:\" -Directory -Recurse

Function IsExclude($Folder) 
	{
		!($NoDelFolder | Where {$_.Contains($folder)})
	}

foreach ($Folder in $Folders_NULL)
	{
		if ((Get-ChildItem -Path $Folder.FullName -Recurse) -eq $null)
    		{
			"Удаляю пустой каталог $($Folder.FullName)..."
			Remove-Item $Folder.FullName | Out-Null
			"Готово!"
		}
	}
If ($EnableNotification)
{
$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo
$Message.Subject = $EmailSubject
$Message.IsBodyHTML = $True
$message.Body = $MesssagyBody | ConvertTo-Html -head $style | Out-String
$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer)
$SMTP.Send($Message)
}



