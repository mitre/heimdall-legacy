$basePath=Get-Location
$pathEnd="ip.csv"
$path= Join-Path -Path $basePath $pathEnd
$folderName=(Get-Date -Format "MM-dd-yyy_HH-mm-ss")
$csv=Import-Csv -Path $path -Header hostname,IPAddress
New-Item -Path "$basePath\$folderName" -ItemType "directory"



function inspecScan([String]$hostName){
    Start-Process "cmd.exe" "/c inspec exec "
}

foreach ($line in $csv) {
    foreach ($item in $line){
        $hostName=@($item)
        Write-Host $hostName
    }
}


