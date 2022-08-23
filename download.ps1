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
Write-Host "Nothing firmware downloader by @sh4ttered V1.1.3"
$msg = 'Do you need the [G]lobal firmware or the [E]uropean firmware (G/E)? '
$response = Read-Host -Prompt $msg
if ($response -eq 'g') {
    Write-Host "Downloading the global firmware v1.1.3"
    Write-Host "This may take a while depending on your internet speed"
    wget -Uri https://android.googleapis.com/packages/ota-api/package/ee4a8d890091f980aa40142d68f46abb1f08e0c5.zip -OutFile fw.zip #global 1.1.3
}
elseif ($response -eq 'e') {
    Write-Host "Downloading the EU firmware v1.1.3"
    Write-Host "This may take a while depending on your internet speed"
    wget -Uri https://android.googleapis.com/packages/ota-api/package/a6f363b6709ec67910b4018526d9525ccb4075f9.zip -OutFile fw.zip #eu 1.1.3
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
