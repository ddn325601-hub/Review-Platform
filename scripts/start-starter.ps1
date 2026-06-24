param(
  [string]$Profile = "local"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $root "config\local-env.ps1"
if (Test-Path -LiteralPath $envFile) {
  . $envFile
}

New-Item -ItemType Directory -Force -Path (Join-Path $root "logs") | Out-Null

$redisPort = if ($env:HMDP_REDIS_PORT) { [int]$env:HMDP_REDIS_PORT } else { 6379 }
$redisPassword = if ($env:HMDP_REDIS_PASSWORD) { $env:HMDP_REDIS_PASSWORD } else { "" }
$redisExisting = Get-NetTCPConnection -LocalPort $redisPort -ErrorAction SilentlyContinue |
  Where-Object State -eq "Listen" |
  Select-Object -ExpandProperty OwningProcess -Unique
if ($redisExisting) {
  Write-Host "Redis already appears to be listening on $redisPort. PID(s): $($redisExisting -join ', ')"
} else {
  $redisRoot = Join-Path $root "resources\runtime\redis-dev"
  New-Item -ItemType Directory -Force -Path $redisRoot | Out-Null
  $redisConfig = Join-Path $redisRoot "redis-dev.conf"
  $requirePass = if ($redisPassword) { "requirepass $redisPassword" } else { "" }
  @"
port $redisPort
bind 127.0.0.1
$requirePass
appendonly yes
dir ./
logfile "redis-dev.log"
"@ | Set-Content -LiteralPath $redisConfig -Encoding ASCII
  $redisExe = if ($env:HMDP_REDIS_SERVER_EXE) { $env:HMDP_REDIS_SERVER_EXE } else { "redis-server.exe" }
  if ((Get-Command $redisExe -ErrorAction SilentlyContinue) -or (Test-Path -LiteralPath $redisExe)) {
    $redis = Start-Process -FilePath $redisExe -ArgumentList @($redisConfig) -WorkingDirectory $redisRoot -WindowStyle Hidden -PassThru
    Write-Host "Started project Redis. PID=$($redis.Id)"
  } else {
    Write-Host "Redis executable not found. Start Redis manually or set HMDP_REDIS_SERVER_EXE."
  }
}

$backendDir = Join-Path $root "backend\hm-dianping-starter"
$stdout = Join-Path $root "logs\backend-starter.out.log"
$stderr = Join-Path $root "logs\backend-starter.err.log"

$existing = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue |
  Where-Object State -eq "Listen" |
  Select-Object -ExpandProperty OwningProcess -Unique
if ($existing) {
  Write-Host "Backend already appears to be listening on 8081. PID(s): $($existing -join ', ')"
} else {
  $proc = Start-Process -FilePath "mvn" `
    -ArgumentList @("spring-boot:run", "-Dspring-boot.run.profiles=$Profile") `
    -WorkingDirectory $backendDir `
    -RedirectStandardOutput $stdout `
    -RedirectStandardError $stderr `
    -WindowStyle Hidden `
    -PassThru
  Write-Host "Started backend starter. PID=$($proc.Id)"
}

$nginxRoot = if ($env:HMDP_NGINX_ROOT) {
  $env:HMDP_NGINX_ROOT
} else {
  Join-Path $root "resources\runtime\nginx-dev\nginx-1.18.0"
}
$nginxExe = Join-Path $nginxRoot "nginx.exe"
if (Test-Path -LiteralPath $nginxExe) {
  $nginxExisting = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue |
    Where-Object State -eq "Listen" |
    Select-Object -ExpandProperty OwningProcess -Unique
  if ($nginxExisting) {
    Write-Host "Frontend already appears to be listening on 8082. PID(s): $($nginxExisting -join ', ')"
  } else {
    $nginx = Start-Process -FilePath $nginxExe -WorkingDirectory $nginxRoot -WindowStyle Hidden -PassThru
    Write-Host "Started frontend nginx. PID=$($nginx.Id)"
  }

  Write-Host "Frontend: http://127.0.0.1:8082"
} else {
  Write-Host "Nginx executable not found. Set HMDP_NGINX_ROOT or start a static server with /api proxy manually."
}
Write-Host "Backend:  http://127.0.0.1:8081"
Write-Host "Logs:     $stdout"
