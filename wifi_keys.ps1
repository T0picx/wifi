$output_file = "$env:USERPROFILE\Desktop\wifi_keys.txt"
Remove-Item -Path $output_file -ErrorAction Ignore

netsh wlan show profile | ForEach-Object {
    if ($_ -match ':\s(.+)$') {
        $wifi_name = $matches[1].Trim()
        $wifi_pwd = (netsh wlan show profile name="$wifi_name" key=clear | Select-String -Pattern 'Key Content\s+:\s(.+)').Matches.Groups[1].Value.Trim()
        if ($wifi_pwd) {
            "$wifi_name : $wifi_pwd" | Out-File -Append -FilePath $output_file
        }
    }
}

Write-Host "Wi-Fi keys saved to $output_file"
