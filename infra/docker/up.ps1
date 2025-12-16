$ErrorActionPreference = 'Stop'

if (-not $env:BW_SESSION) {
  throw 'BW_SESSION não definida. Rode: $env:BW_SESSION = bw unlock --raw'
}

# IDs DEVEM vir de variáveis de ambiente
$ID_PG   = $env:LIFEOPS_BW_ID_PG
$ID_EK   = $env:LIFEOPS_BW_ID_EK
$ID_AUTH = $env:LIFEOPS_BW_ID_AUTH

if ([string]::IsNullOrWhiteSpace($ID_PG))   { throw 'LIFEOPS_BW_ID_PG não definida.' }
if ([string]::IsNullOrWhiteSpace($ID_EK))   { throw 'LIFEOPS_BW_ID_EK não definida.' }
if ([string]::IsNullOrWhiteSpace($ID_AUTH)) { throw 'LIFEOPS_BW_ID_AUTH não definida.' }

$pgItem   = bw get item $ID_PG   | ConvertFrom-Json
$ekItem   = bw get item $ID_EK   | ConvertFrom-Json
$authItem = bw get item $ID_AUTH | ConvertFrom-Json

$pgUser   = $pgItem.login.username
$pgPass   = $pgItem.login.password
$ekValue  = $ekItem.notes
$authUser = $authItem.login.username
$authPass = $authItem.login.password

if ([string]::IsNullOrWhiteSpace($pgUser))   { throw 'POSTGRES_USER vazio no Bitwarden.' }
if ([string]::IsNullOrWhiteSpace($pgPass))   { throw 'POSTGRES_PASSWORD vazio no Bitwarden.' }
if ([string]::IsNullOrWhiteSpace($ekValue))  { throw 'N8N_ENCRYPTION_KEY vazia (notes).' }
if ([string]::IsNullOrWhiteSpace($authUser)) { throw 'N8N_BASIC_AUTH_USER vazio.' }
if ([string]::IsNullOrWhiteSpace($authPass)) { throw 'N8N_BASIC_AUTH_PASSWORD vazia.' }

$ekValue = $ekValue.Trim()
if ($ekValue.Length -lt 32) {
  throw 'N8N_ENCRYPTION_KEY curta demais (<32).'
}

# Escape crítico para Docker Compose
$env:POSTGRES_USER            = $pgUser.Trim()
$env:POSTGRES_PASSWORD        = ($pgPass   -replace '\$', '$$').Trim()
$env:N8N_ENCRYPTION_KEY       = ($ekValue  -replace '\$', '$$').Trim()
$env:N8N_BASIC_AUTH_USER      = ($authUser -replace '\$', '$$').Trim()
$env:N8N_BASIC_AUTH_PASSWORD  = ($authPass -replace '\$', '$$').Trim()

Push-Location $PSScriptRoot
docker compose --env-file .env up -d
if ($LASTEXITCODE -ne 0) {
  Pop-Location
  throw "docker compose falhou (exit code $LASTEXITCODE)"
}
Pop-Location

Write-Host 'LifeOps stack iniciado (segredos via Bitwarden, runtime-only).'
