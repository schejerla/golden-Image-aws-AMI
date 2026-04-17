# Example: install updates & basic tools

Write-Host "Installing Windows Updates..."
Install-WindowsFeature -Name Web-Server

# Example software install
# choco install googlechrome -y

Write-Host "Setup complete"
