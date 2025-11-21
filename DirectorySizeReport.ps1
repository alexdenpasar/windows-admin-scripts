Get-ChildItem C:\ -Force -ErrorAction SilentlyContinue | 
    Where-Object {$_.PSIsContainer} | 
    ForEach-Object {
        $size = (Get-ChildItem $_.FullName -Recurse -Force -ErrorAction SilentlyContinue | 
                 Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
        [PSCustomObject]@{
            Folder = $_.FullName
            'Size(GB)' = [math]::Round($size/1GB,2)
        }
    } | Sort-Object 'Size(GB)' -Descending | Format-Table -AutoSize
