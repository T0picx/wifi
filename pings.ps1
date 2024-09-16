# Prompt the user for the network prefix
$networkPrefix = Read-Host "Enter the network prefix (e.g., 192.168.1)"

# Prompt the user for the range of IP addresses
$startRange = [int] (Read-Host "Enter the start range (e.g., 1)")
$endRange = [int] (Read-Host "Enter the end range (e.g., 254)")

# Validate the IP range
if ($startRange -lt 1 -or $endRange -gt 254 -or $startRange -gt $endRange) {
    Write-Host "Invalid IP range. Please ensure that the start range is between 1 and 254, and the start range is less than or equal to the end range."
    exit
}

# Loop through the range of IP addresses and ping each one
for ($i = $startRange; $i -le $endRange; $i++) {
    $ip = "$networkPrefix.$i"
    $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet

    if ($pingResult) {
        Write-Host "$ip is Online"

    } else {
        Write-Host "$ip is not Pingable"
    }
}
