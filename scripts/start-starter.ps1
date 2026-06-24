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

$redisExisting = Get-NetTCPConnection -LocalPort 6380 -ErrorAction SilentlyContinue |
  Where-Object State -eq "Listen" |
  Select-Object -ExpandProperty OwningProcess -Unique
if ($redisExisting) {
  Write-Host "Project Redis already appears to be listening on 6380. PID(s): $($redisExisting -join ', ')"
} else {
  $redisRoot = Join-Path $root "resources\runtime\redis-dev"
  New-Item -ItemType Directory -Force -Path $redisRoot | Out-Null
  $redisConfig = Join-Path $redisRoot "redis-6380.conf"
  @"
port 6380
bind 127.0.0.1
requirepass l798267901
appendonly yes
dir ./
logfile "redis-6380.log"
"@ | Set-Content -LiteralPath $redisConfig -Encoding ASCII
  $redisExe = "D:\Program Files\Redis\redis-server.exe"
  if (Test-Path -LiteralPath $redisExe) {
    $redis = Start-Process -FilePath $redisExe -ArgumentList @($redisConfig) -WorkingDirectory $redisRoot -WindowStyle Hidden -PassThru
    Write-Host "Started project Redis. PID=$($redis.Id)"
  } else {
    Write-Host "Redis executable not found at $redisExe. Start Redis 6380 manually or update HMDP_REDIS_* variables."
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

$nginxRoot = Join-Path $root "resources\runtime\nginx-dev\nginx-1.18.0"
if (-not (Test-Path -LiteralPath (Join-Path $nginxRoot "nginx.exe"))) {
  $runtime = Join-Path $root "resources\runtime\nginx-dev"
  New-Item -ItemType Directory -Force -Path $runtime | Out-Null
  Expand-Archive -LiteralPath (Join-Path $root "resources\runtime\nginx-1.18.0.zip") -DestinationPath $runtime -Force
  (Get-Content -LiteralPath (Join-Path $nginxRoot "conf\nginx.conf") -Raw) -replace "listen\s+8080;", "listen       8082;" |
    Set-Content -LiteralPath (Join-Path $nginxRoot "conf\nginx.conf") -Encoding UTF8
}

$nginxExisting = Get-NetTCPConnection -LocalPort 8082 -ErrorAction SilentlyContinue |
  Where-Object State -eq "Listen" |
  Select-Object -ExpandProperty OwningProcess -Unique
if ($nginxExisting) {
  Write-Host "Frontend already appears to be listening on 8082. PID(s): $($nginxExisting -join ', ')"
} else {
  $nginx = Start-Process -FilePath (Join-Path $nginxRoot "nginx.exe") -WorkingDirectory $nginxRoot -WindowStyle Hidden -PassThru
  Write-Host "Started frontend nginx. PID=$($nginx.Id)"
}

Write-Host "Frontend: http://127.0.0.1:8082"
Write-Host "Backend:  http://127.0.0.1:8081"
Write-Host "Logs:     $stdout"
