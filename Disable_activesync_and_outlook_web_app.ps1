$ServerFQDN = "exchangeserver"
$mailbox =  $args[0]
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$ServerFQDN/PowerShell/ -Authentication Kerberos
Import-PSSession $Session


Set-CASMailbox -Identity $mailbox -ActiveSyncEnabled $False
Set-CASMailbox -Identity $mailbox -OWAEnabled $False

Remove-PSSession $Session
