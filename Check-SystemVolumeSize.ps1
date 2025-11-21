# Проверить размер System Volume Information
Get-ChildItem "C:\System Volume Information" -Force -Recurse -ErrorAction SilentlyContinue | 
    Measure-Object -Property Length -Sum | 
    Select-Object @{Name="Size(GB)";Expression={[math]::Round($_.Sum/1GB,2)}}
