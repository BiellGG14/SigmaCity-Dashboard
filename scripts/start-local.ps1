param(
  [switch]$SkipFrontendInstall
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$frontendDir = Join-Path $repoRoot "frontend"
$backendDir = Join-Path $repoRoot "backend"
$rscriptPath = "C:\Program Files\R\R-4.5.3\bin\Rscript.exe"

if (-not (Test-Path $frontendDir)) {
  throw "Pasta frontend nao encontrada."
}

if (-not (Test-Path $backendDir)) {
  throw "Pasta backend nao encontrada."
}

if (-not (Test-Path $rscriptPath)) {
  throw "Rscript nao encontrado em '$rscriptPath'. Instale o R ou ajuste o caminho no script."
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  throw "Node.js nao encontrado. Instale o Node.js antes de rodar o projeto."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  throw "npm nao encontrado. Instale o Node.js antes de rodar o projeto."
}

if ((-not $SkipFrontendInstall) -and (-not (Test-Path (Join-Path $frontendDir "node_modules")))) {
  Write-Host "Dependencias do frontend nao encontradas. Rodando npm install..." -ForegroundColor Cyan
  Push-Location $frontendDir
  try {
    npm install
  }
  finally {
    Pop-Location
  }
}

$backendCommand = @"
`$env:R_LIBS_USER = Join-Path `$env:USERPROFILE 'Documents\R\win-library\4.5'
Set-Location '$backendDir'
& '$rscriptPath' run_api.R
"@

$frontendCommand = @"
Set-Location '$frontendDir'
npm run dev
"@

Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", $backendCommand -WorkingDirectory $backendDir
Start-Process powershell.exe -ArgumentList "-NoExit", "-Command", $frontendCommand -WorkingDirectory $frontendDir

Write-Host ""
Write-Host "Frontend e backend foram iniciados em janelas separadas." -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000/portal"
Write-Host "Backend:  http://127.0.0.1:8000/api/health"
Write-Host ""
Write-Host "Para encerrar ambos depois, rode: .\scripts\stop-local.ps1"
