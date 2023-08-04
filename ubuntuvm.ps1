# Here I scripted the Hyper-V VM creation. This particular script creates a vm with specified name and RAM with standart filepath, disk size and cores.
# I strongly recommend you to modify this script for your needs.
# This script works for me, but there is clearly some space for optimization.

param(
   $VMName,                     # We push 2 params. This one is a name
   $MemoryStartup = 2GB         # virtual memory allocated
)

$VM = @{                                                # Here we manifest a vm.
    Name = $VMName                                      
    MemoryStartupBytes = $MemoryStartup                 # Specifying memory amount at startup. Very important to make this amount sufficient. Or, in case of windows, you will get the 0x7D BugChech code. BTW, it's article in microsoft learn is very funny.
    Generation = 2                                      # There is almost no reason to use the first generation.
    NewVHDPath = "I:\hyperv\vdisks\$VMName.vhdx"        # Path to virdisc. Please specify your own path, for your own's sake. Or clear for default.
    NewVHDSizeBytes = 15GB                              # Disk size. For Ubuntu Server this is my sufficient minimum.
    BootDevice = "VHD"                                  # Setting boot device to disk. Here is a space for improvement
    Path = "I:\hyperv\$VMName"                          # Path for vm itself
    SwitchName = "Extnet"                               # Connected switch. Mine is Extnet, but you must put yours.
}

New-VM @VM                          # Creating vm. Next we will mod the vm itself.
get-vm $VMName | Set-VMFirmware -EnableSecureBoot Off                           # Turning off the SecureBoot, so vm could boot into something other than Windows
Add-VMDvdDrive -VMName $VMName -Path "ubuntu-22.04.2-live-server-amd64.iso"     # Creating a dvd drive. I used here ubuntu image. You just put path to your desired image.
$dvd = Get-VMDvdDrive -VMName $VMName                                           # Getting it
$hd = Get-VMHardDiskDrive -VMName $VMName                                       # Getting the hard drive
get-vm $VMName | Set-VMFirmware -BootOrder $dvd, $hd                            # Putting order for drives.
get-vm $VMName | Set-VMProcessor -Count 2                                       # Setting vm to use 2 cores.
Set-VMMemory $VMName -DynamicMemoryEnabled $true -MinimumBytes 64MB -StartupBytes $MemoryStartup -MaximumBytes 2GB -Priority 80 -Buffer 25      # Setting memory params. Modify at your will.