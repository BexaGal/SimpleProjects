# This simple script emulates ssh-copy-id in powershell env.

param(
    $ServerAndLogin
)
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub | ssh $ServerAndLogin "cat >> .ssh/authorized_keys"