#Set-ExecutionPolicy Bypass
Set-VpnConnection –Name VPN-Name -SplitTunneling $True
Add-VpnConnectionRoute -ConnectionName "VPN-Name" -DestinationPrefix 192.168.1.0/24 -PassThru