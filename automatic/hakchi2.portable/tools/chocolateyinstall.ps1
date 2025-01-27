﻿$ErrorActionPreference = 'Stop'

$ToolsDir   = Join-Path $env:ChocolateyPackageFolder 'tools'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter 'hakchi*' | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = (Join-path $env:ChocolateyPackageFolder ($env:ChocolateyPackageName.split('.')[0] + $env:ChocolateyPackageVersion))
}
Get-ChocolateyUnzip @InstallArgs

$files = get-childitem $InstallArgs.Destination -include *.exe -recurse
foreach ($file in $files) {
   if ($file.name -eq 'hakchi.exe') {
      $target = $file.fullname
   } else {
      #generate an ignore file
      $null = New-Item "$($file.FullName).ignore" -Type file -Force
   }
}
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'hakchi2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target -RunAsAdmin
