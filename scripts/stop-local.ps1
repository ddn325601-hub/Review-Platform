$ErrorActionPreference = "SilentlyContinue"

foreach ($port in 8081, 8082, 3307, 6380) {
  $pids = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue |
    Where-Object State -eq "Listen" |
    Select-Object -ExpandProperty OwningProcess -Unique
  foreach ($pidValue in $pids) {
    Stop-Process -Id $pidValue -Force
    Write-Host "Stopped process $pidValue on port $port"
  }
}
