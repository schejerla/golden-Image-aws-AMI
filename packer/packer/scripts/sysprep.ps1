Write-Host "Running Sysprep..."

Start-Process -FilePath "C:\Windows\System32\Sysprep\Sysprep.exe" `
  -ArgumentList "/oobe /generalize /shutdown /quiet" `
  -Wait
