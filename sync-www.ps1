# Baut das ClipComplete-Frontend (Haupt-Repo) und kopiert es in www/.
# Voraussetzung: ai-video-studio liegt als Schwester-Ordner ODER Pfad per
#   $env:CLIPCOMPLETE_REPO setzen.
$ErrorActionPreference = "Stop"
$repo = $env:CLIPCOMPLETE_REPO
if (-not $repo) {
  foreach ($cand in @("..\ai-video-studio", "$env:USERPROFILE\ai-video-studio")) {
    if (Test-Path (Join-Path $cand "frontend\package.json")) { $repo = $cand; break }
  }
}
if (-not $repo) { Write-Error "ai-video-studio Repo nicht gefunden. CLIPCOMPLETE_REPO setzen."; exit 1 }
Write-Host "==> Frontend bauen aus $repo"
Push-Location (Join-Path $repo "frontend")
npm run build
Pop-Location
Write-Host "==> dist -> www kopieren"
Remove-Item -Recurse -Force www -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force www | Out-Null
Copy-Item -Recurse (Join-Path $repo "frontend\dist\*") www\
Write-Host "[OK] www aktualisiert - jetzt: npx cap sync"
