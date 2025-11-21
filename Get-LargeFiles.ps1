Get-ChildItem C:\ -Force -File -ErrorAction SilentlyContinue | 
    Where-Object {$_.Length -gt 1GB} | 
    Sort-Object Length -Descending | 
    Select-Object FullName, @{Name="Size(GB)";Expression={[math]::Round($_.Length/1GB,2)}} | 
    Format-Table -AutoSize
