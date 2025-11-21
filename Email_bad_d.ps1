$DateTime = Get-Date -Format “dd-MM-yyyy HH:mm:ss”
$EmailFrom = “1c@server.com”
$EmailTo = “user@server.com”
$Subject = “[ERROR] Backup database 1c”
$Body = “Error of daily backup of 1C database. Show logs on srv-lib. Completion time: $DateTime”
$SmtpServer = “smtp.server.com”
$smtp = New-Object net.mail.smtpclient($SmtpServer)
$smtp.Send($EmailFrom, $EmailTo, $Subject, $Body)
