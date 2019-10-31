$basePath=Get-Location
$pathEnd="ip.csv"
$path= Join-Path -Path $basePath $pathEnd
$folderName=(Get-Date -Format "MM-dd-yyy_HH-mm-ss")
$hostCSV=Import-Csv -Path $path -Header hostname,IPAddress
$userCredentials=(Get-Content "$basePath\userCredentials.csv").split(",")
$Credential = Get-Credential
Write-Host $Credential



New-Item -Path "$basePath\$folderName" -ItemType "directory"

function inspecScan([String]$hostName, [String]$ipAddress,[String]$username,[String]$password){
    Start-Process "cmd.exe" "/c inspec exec "
}

foreach ($item in $hostCSV) {
    $hostName=$($item.hostname)
    $ipAddress=$($item.IPAddress)
}






