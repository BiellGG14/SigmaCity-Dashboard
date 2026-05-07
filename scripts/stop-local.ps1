$ErrorActionPreference = "SilentlyContinue"

$ports = 3000, 8000

foreach ($port in $ports) {
  $pids = Get-NetTCPConnection -LocalPort $port -State Listen | Select-Object -ExpandProperty OwningProcess -Unique
  foreach ($pid in $pids) {
    Stop-Process -Id $pid -Force
    Write-Host "Processo na porta $port encerrado (PID $pid)." -ForegroundColor Yellow
  }
}

Write-Host "Encerramento concluido." -ForegroundColor Green
