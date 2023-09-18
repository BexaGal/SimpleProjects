# Here I scripted the Hyper-V VM creation. This particular script creates a vm with specified name and RAM with standart filepath, disk size and cores.
# I strongly recommend you to modify this script for your needs.
# This script works for me, but there is clearly some space for optimization.

param(
   $VMName,                                                     # We push 2 params. This one is a name
   $MemoryStartup = 2GB,                                        # virtual memory allocated
   $Switch = "Extnet",                                          # Connected switch. Mine is Extnet, but you must put yours.
   $vmpath = "C:\hyperv\$VMName",                               # Path for vm itself
   $VirtualDiskPath = "$vmpath\..\vdisks\$VMName.vhdx",         # Path to virdisc. Please specify your own path, for your own's sake. Or clear for default.
   $VirDiskSize = 15GB,                                         # Disk size. For Ubuntu Server this is my sufficient minimum.
   $ISOpath = "ubuntu-20.04.6-live-server-amd64.iso",           # Path to ISO file to install OS from.
   [switch]$AutoCheckpointDisable,                              # This param defines if VM will be created with autosnapshots.
   $CoreCount = 2,                                              # Setting core amount. 2 by default
   [switch]$NestedVirtualization                                # Switch do define if VM will get nested virtualization options
)

$VM = @{                                                # Here we manifest a vm.
    Name = $VMName                                      
    MemoryStartupBytes = $MemoryStartup                 # Specifying memory amount at startup. Very important to make this amount sufficient. Or, in case of windows, you will get the 0x7D BugChech code. BTW, it's article in microsoft learn is very funny.
    Generation = 2                                      # There is almost no reason to use the first generation.
    NewVHDPath = $VirtualDiskPath                       
    NewVHDSizeBytes = $VirDiskSize                      
    BootDevice = "VHD"                                  # Setting boot device to disk. Here is a space for improvement
    Path = $vmpath                                      
    SwitchName = $switch                                
}

New-VM @VM                          # Creating vm. Next we will mod the vm itself.
get-vm $VMName | Set-VMFirmware -EnableSecureBoot Off                           # Turning off the SecureBoot, so vm could boot into something other than Windows
Add-VMDvdDrive -VMName $VMName -Path $ISOpath                                   # Creating a dvd drive. I used here ubuntu image. You just put path to your desired image.
$dvd = Get-VMDvdDrive -VMName $VMName                                           # Getting it
$hd = Get-VMHardDiskDrive -VMName $VMName                                       # Getting the hard drive
get-vm $VMName | Set-VMFirmware -BootOrder $dvd, $hd                            # Putting order for drives.
get-vm $VMName | Set-VMProcessor -Count $CoreCount                              # Setting vm to use set amount of cores cores.
if ($AutoCheckpointDisable -eq $true){                                          # Turns off automatic checkpoint creation
    set-vm -Name $VMName -AutomaticCheckpointsEnabled $false
}
if ($NestedVirtualization -eq $true){
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
}else {
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $false
}
Set-VMMemory $VMName -DynamicMemoryEnabled $true -MinimumBytes 64MB -StartupBytes $MemoryStartup -MaximumBytes $MemoryStartup -Priority 80 -Buffer 25      # Setting memory params. Modify at your will.