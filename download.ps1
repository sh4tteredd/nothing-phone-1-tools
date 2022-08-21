#Function Test-CommandExists {
#    Param ($command)
#    if (Get-Command $command -errorAction SilentlyContinue) {
#        "$command exists"
#    }
#    else {
#        "$command does not exists"
#        Write-Host -NoNewLine 'Press any key to continue...';
#        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
#        exit
#    }
#}
function clean {
    Remove-Item ".\extracted_*" -Force -Recurse
    Remove-Item ".\extracted_*" -Force -Recurse
    Remove-Item .\payload-dumper-go.exe
    Remove-Item .\payload.bin
    Remove-Item .\payload-dumper-go.tar.gz
    
}
#Test-CommandExists("fastboot")
Write-Host "Nothing firmware downloader by @sh4ttered V1.1.2"
$msg = 'Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? '
$response = Read-Host -Prompt $msg
if ($response -eq 'g') {
    Write-Host "Downloading the global firmware v1.1.2"
    Write-Host "This may take a while depending on your internet speed"
    wget -Uri https://android.googleapis.com/packages/ota-api/package/a244285dfb5aef198999463c2d55f353ed0e7b1b.zip -OutFile fw.zip #global 1.1.2
}
elseif ($response -eq 'e') {
    Write-Host "Downloading the EU firmware v1.1.2"
    Write-Host "This may take a while depending on your internet speed"
    wget -Uri https://android.googleapis.com/packages/ota-api/package/0f77244380edcc46a4d60397f5c22ea911352bfe.zip -OutFile fw.zip #eu 1.1.2
}
else {
    Write-Host "Invalid Input!"
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    exit
}
Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead(".\fw.zip")
$zip.Entries | where { $_.Name -like 'payload.bin' } | foreach { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, ".\payload.bin", $true) }
$zip.Dispose()
wget -Uri https://github.com/ssut/payload-dumper-go/releases/download/1.2.2/payload-dumper-go_1.2.2_windows_amd64.tar.gz -OutFile payload-dumper-go.tar.gz
tar -zxf payload-dumper-go.tar.gz payload-dumper-go.exe
.\payload-dumper-go.exe payload.bin
if (-not (Test-Path -Path ".\images") ) {
    New-Item -ItemType "directory" -Path ".\images" | Out-Null
}
Move-Item -Path .\extracted*\* -Destination .\images -Force
clean
$msg = 'Do you want to flash your phone now? (y/N)? '
$response = Read-Host -Prompt $msg
if ($response -eq 'y') {
    Write-Host "Starting the flash script..."
    Start-Process -FilePath ".\flash_all.bat"
}
else {
    Write-Host -NoNewLine 'Press any key to continue...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}
