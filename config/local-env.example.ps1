# Copy this file to config/local-env.ps1 when you want to override local settings.
# Defaults already match the workspace runtime started by Codex:
# MySQL 127.0.0.1:3307, user root, empty password; Redis 127.0.0.1:6379, empty password.

$env:HMDP_MYSQL_HOST = "127.0.0.1"
$env:HMDP_MYSQL_PORT = "3307"
$env:HMDP_MYSQL_DATABASE = "hmdp"
$env:HMDP_MYSQL_USERNAME = "root"
$env:HMDP_MYSQL_PASSWORD = "l798267901"

$env:HMDP_REDIS_HOST = "127.0.0.1"
$env:HMDP_REDIS_PORT = "6380"
$env:HMDP_REDIS_PASSWORD = "l798267901"
