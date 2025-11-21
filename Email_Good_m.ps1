$DateTime = Get-Date -Format “dd-MM-yyyy HH:mm:ss”
$EmailFrom = “1c@server.com”
$EmailTo = “user@server.com”
$Subject = “[Success] Backup database 1c”
$Body = “Backup of 1C databases has been successfully completed. Completion time: $DateTime”
$SmtpServer = “smtp.server.com”
$smtp = New-Object net.mail.smtpclient($SmtpServer)
$smtp.Send($EmailFrom, $EmailTo, $Subject, $Body)
