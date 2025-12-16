$ErrorActionPreference = 'Stop'

if (-not $env:BW_SESSION) {
  throw 'BW_SESSION não definida. Rode: $env:BW_SESSION = bw unlock --raw'
}

$ID_PG   = '7eba9e0b-2eec-4fb3-923b-b3b4011d3c73'
$ID_EK   = '84ca1390-892e-4ffe-a0f0-b3b500ce1d12'
$ID_AUTH = 'd59d9eb8-d289-460c-9cdc-b3b4011de334'

if ([string]::IsNullOrWhiteSpace($ID_PG))   { throw 'ID_PG vazio.' }
if ([string]::IsNullOrWhiteSpace($ID_EK))   { throw 'ID_EK vazio.' }
if ([string]::IsNullOrWhiteSpace($ID_AUTH)) { throw 'ID_AUTH vazio.' }

$pgItem   = bw get item $ID_PG   | ConvertFrom-Json
$ekItem   = bw get item $ID_EK   | ConvertFrom-Json
$authItem = bw get item $ID_AUTH | ConvertFrom-Json

$pgUser   = $pgItem.login.username
$pgPass   = $pgItem.login.password
$ekValue  = $ekItem.notes
$authUser = $authItem.login.username
$authPass = $authItem.login.password

if ([string]::IsNullOrWhiteSpace($pgUser))   { throw 'POSTGRES_USER vazio no item LifeOps Postgres.' }
if ([string]::IsNullOrWhiteSpace($pgPass))   { throw 'POSTGRES_PASSWORD vazio no item LifeOps Postgres.' }
if ([string]::IsNullOrWhiteSpace($ekValue))  { throw 'N8N_ENCRYPTION_KEY vazia no item LifeOps N8N EK (Anotação).' }
if ([string]::IsNullOrWhiteSpace($authUser)) { throw 'N8N_BASIC_AUTH_USER vazio no item LifeOps N8N Basic Auth.' }
if ([string]::IsNullOrWhiteSpace($authPass)) { throw 'N8N_BASIC_AUTH_PASSWORD vazia no item LifeOps N8N Basic Auth.' }

$ekValue = $ekValue.Trim()
if ($ekValue.Length -lt 32) { throw 'N8N_ENCRYPTION_KEY curta demais (<32).' }

# Escape crítico para Docker Compose (evita $VAR / ${VAR})
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

