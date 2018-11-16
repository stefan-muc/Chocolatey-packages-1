﻿$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe').FullName

if (-not $InstallerPath) {
   $ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName
   Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination $toolsDir
   $InstallerPath = (Get-ChildItem -Path $toolsDir -filter '*.exe').FullName
}

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $InstallerPath
   silentArgs     = "/silent /Extract /dir=`"$env:ChocolateyPackageFolder`""
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

Get-ChildItem -Path $env:ChocolateyPackageFolder -filter 'setup.exe' -Recurse | 
   ForEach-Object { $null = New-Item "$($_.FullName).ignore" -Type file -Force }


