##### Create the DXDiag File first ##########

# Define the output path for the DxDiag file
$outputPath = "$env:USERPROFILE\Desktop\dxdiag.txt"

# Start DxDiag and output to the specified location
Start-Process -FilePath "dxdiag.exe" -ArgumentList "/t $outputPath" -NoNewWindow -Wait

# Wait for the file to be created and monitor progress
Write-Host "Generating DxDiag report. Please wait..."
while (-not (Test-Path -Path $outputPath)) {
    Start-Sleep -Seconds 1  # Wait for 1 second before checking again
}

# Confirm the file was created
Write-Host "DxDiag report successfully created at: $outputPath"

##### Create an anonymized version of the the DXDiag File second ##########

# Read the content of dxdiag.txt into a variable
$content = Get-Content -Path "$env:USERPROFILE\Desktop\dxdiag.txt"

# Define patterns of information to be masked
$patterns = @(
    'System Manufacturer:.*',
    'Language:.*',
    'System Model:.*',
    'BIOS:.*',
    'Processor:.*',
    'Machine Name:.*',
    'Machine ID:.*',
    'Operating System:.*',
    'System Locale:.*',
    'User Locale:.*',
    'Monitor Id:.*',
    'Time Zone:.*',
    'DirectX Version:.*',
    'DX Setup Parameters:.*',
    'Card name:.*',
    'Manufacturer:.*',
    'Chip type:.*',
    'Monitor Model:.*',
    'Sound Devices:.*',
    'Description:.*',
    'Driver Version:.*',
    'Driver Date:.*',
    'DirectInput Devices:.*',
    'USB Device:.*',
    'MAC Address:.*',
    'Identifier:.*',
    'UUID:.*',
    'Hardware IDs:.*'
)

# Loop through each pattern and replace matched lines with "N/A"
foreach ($pattern in $patterns) {
    $content = $content -replace $pattern, "$($pattern -replace ':.*', ': N/A')"
}

# Replace occurrences of "C:\Windows\System32" with ""
$content = $content -replace 'C:\\Windows\\System32', ''
# Replace occurrences of "C:\Windows" with "\"
$content = $content -replace 'C:\\Windows', '\'
# Replace occurrences of "D:\Windows\System32" with ""
$content = $content -replace 'D:\\Windows\\System32', ''
# Replace occurrences of "D:\Windows" with "\"
$content = $content -replace 'D:\\Windows', '\'

# Write the modified content to a new file in the same folder
$anonOutputPath = "$env:USERPROFILE\Desktop\dxdiag_anonymized.txt"
Set-Content -Path $anonOutputPath -Value $content

Write-Host "DxDiag report successfully created at: $anonOutputPath"
Start-Process -FilePath "notepad.exe" -ArgumentList $anonOutputPath


