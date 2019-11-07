$basePath=Get-Location
$pathEnd="ip.csv"
$path= Join-Path -Path $basePath $pathEnd
$folderName=(Get-Date -Format "MM-dd-yyy_HH-mm-ss")
$hostCSV=Import-Csv -Path $path -Header hostname,IPAddress
$username=Get-Content "$basePath\username.txt" | ConvertTo-SecureString
$password=Get-Content "$basePath\password.txt" | ConvertTo-SecureString




New-Item -Path "$basePath\$folderName" -ItemType "directory"

function inspecScan(){
    Start-Process "cmd.exe" "/c inspec exec stig-microsoft-windows-server-2016-v1r14-baseline -t winrm://$username@$ipAddress --password=$password --reporter cli json:$basePath\$folderName\$hostname.json"
}

foreach ($item in $hostCSV) {
    $hostName=$($item.hostname)
    $ipAddress=$($item.IPAddress)
    inspecScan($hostName, $ipAddress, $username, $password)
}

