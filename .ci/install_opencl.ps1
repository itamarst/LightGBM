
if ($env:TASK -eq "bdist") {
  Write-Output "Installing OpenCL CPU platform"

  Write-Output "Agent platform information:"
  Get-WmiObject -Class Win32_ComputerSystem
  Get-WmiObject -Class Win32_Processor
  Get-WmiObject -Class Win32_BIOS

  Write-Output "Downloading OpenCL runtime"
  Invoke-WebRequest -OutFile AMD-APP-SDKInstaller-v3.0.130.135-GA-windows-F-x64.exe -Uri https://gamma-rho.com/AMD-APP-SDKInstaller-v3.0.130.135-GA-windows-F-x64.exe
  Write-Output "Installing OpenCL runtime"
  Invoke-Command -ScriptBlock {Start-Process 'AMD-APP-SDKInstaller-v3.0.130.135-GA-windows-F-x64.exe' -ArgumentList '/S /V"/quiet /norestart /passive /log amd_opencl_sdk.log"' -Wait}

  $property = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Khronos\OpenCL\Vendors
  if ($property -eq $null) {
    Write-Output "Unable to install OpenCL CPU platform"
    Write-Output "Setting EXIT"
    $host.SetShouldExit(-1)
    Exit -1
  } else {
    Write-Output "Successfully installed OpenCL CPU platform"
    Write-Output "Current OpenCL drivers:"
    Write-Output $property
  }
} else {
  Write-Output "OpenCL installation not required"
}

