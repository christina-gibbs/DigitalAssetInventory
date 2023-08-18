
$targetFolder = Read-Host "Enter the target folder path"
$outputPath = Join-Path $targetFolder "FileType_Count_Size.csv"

$filesByType = Get-ChildItem -File -Recurse -Force $targetFolder | Group-Object Extension

$dataColl = $filesByType | ForEach-Object {
    $fileType = $_.Name
    $fileCount = $_.Count
    $totalSize = ($_.Group | Measure-Object -Sum Length).Sum

    $fileSizeMB = '{0:N2}' -f ($totalSize / 1Mb)
    $fileSizeGB = '{0:N2}' -f ($totalSize / 1Gb)
    $fileSizeTB = '{0:N2}' -f ($totalSize / 1Tb)

    [PSCustomObject]@{
        "FileType" = $fileType
        "FileCount" = $fileCount
        "TotalSizeMB" = $fileSizeMB
        "TotalSizeGB" = $fileSizeGB
        "TotalSizeTB" = $fileSizeTB
    }
}

$dataColl | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Data exported to: $outputPath"
