$targetFolder = Read-Host "Enter the target folder path"
$outputPath = Join-Path $targetFolder "Folder_IndividualFileInfo.csv"

$fileSizeUnit = Read-Host "Enter the desired file size unit (MB, GB, TB)"

$dataColl = Get-ChildItem -Force $targetFolder -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    $fullFilePath = $_.FullName
    $fileName = $_.Name
    $fileType = $_.Extension
    $fileSize = $_.Length
    $dateCreated = $_.CreationTime
    $dateLastModified = $_.LastWriteTime

    $fileSizeFormatted = switch ($fileSizeUnit) {
        "MB" { '{0:N2} MB' -f ($fileSize / 1MB) }
        "GB" { '{0:N2} GB' -f ($fileSize / 1GB) }
        "TB" { '{0:N2} TB' -f ($fileSize / 1TB) }
        default { "Invalid Unit" }
    }

    [PSCustomObject]@{
        "FullFilePath" = $fullFilePath
        "FileName" = $fileName
        "FileType" = $fileType
        "FileSize ($fileSizeUnit)" = $fileSizeFormatted
        "DateCreated" = $dateCreated
        "DateLastModified" = $dateLastModified
    }
}

$dataColl | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Data exported to: $outputPath"
