$targetFolder = Read-Host "Enter the target folder path"
$outputPath = Join-Path $targetFolder "Folder_FileCount_Size.csv"

$dataColl = Get-ChildItem -Force $targetFolder -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $fileCount = 0
    $folderSize = 0

    Get-ChildItem -Recurse -Force $_.FullName -File -ErrorAction SilentlyContinue | ForEach-Object {
        $fileCount++
        $folderSize += $_.Length
    }

    $folderName = $_.FullName
    $folderSizeMB = '{0:N2}' -f ($folderSize / 1Mb)
    $folderSizeGB = '{0:N2}' -f ($folderSize / 1Gb)
    $folderSizeTB = '{0:N2}' -f ($folderSize / 1Tb)

    [PSCustomObject]@{
        "FolderName" = $folderName
        "FileCount" = $fileCount
        "FolderSizeMB" = $folderSizeMB
        "FolderSizeGB" = $folderSizeGB
        "FolderSizeTB" = $folderSizeTB
    }
}

$dataColl | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Data exported to: $outputPath"
