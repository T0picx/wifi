$output_file = "$env:USERPROFILE\Desktop\wifi_keys.txt"
Remove-Item -Path $output_file -ErrorAction Ignore

# Get the list of Wi-Fi profiles
$profiles = netsh wlan show profile | Select-String ":\s(.+)$"

foreach ($profile in $profiles) {
    # Extract Wi-Fi profile name
    if ($profile -match ':\s(.+)$') {
        $wifi_name = $matches[1].Trim()

        # Retrieve Wi-Fi password (if any)
        $wifi_pwd = netsh wlan show profile name="$wifi_name" key=clear | Select-String -Pattern 'Key Content\s+:\s(.+)'

        if ($wifi_pwd) {
            # Extract password value
            $pwd_value = $wifi_pwd.Matches.Groups[1].Value.Trim()
            if ($pwd_value) {
                "$wifi_name : $pwd_value" | Out-File -Append -FilePath $output_file
            } else {
                "$wifi_name : No password found" | Out-File -Append -FilePath $output_file
            }
        } else {
            "$wifi_name : No password found or profile not accessible" | Out-File -Append -FilePath $output_file
        }
    }
}

Write-Host "Wi-Fi keys saved to $output_file"
