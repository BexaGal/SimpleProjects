# This command makes UAC always use Windows Hello, even if you work under admin. Useful for security's sake (keyboard control malware, f.e.)

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1