# Estado del kit motion-graphics-pbt: repos, skills enlazadas, herramientas y librerias.
$Root = if ($env:MG_ROOT) { $env:MG_ROOT } else { Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'motion-graphics' }
$M = Get-Content (Join-Path $PSScriptRoot '..\manifest.json') -Raw | ConvertFrom-Json
$skills = Join-Path $HOME '.claude\skills'
$bad = 0
function S($ok, $txt) { if ($ok) { Write-Host "[OK] $txt" -ForegroundColor Green } else { Write-Host "[--] $txt" -ForegroundColor Yellow; $script:bad++ } }
foreach ($c in 'git', 'node', 'npx', 'uv', 'ffmpeg', 'ffprobe', 'bun', 'jq', 'earshot') { S ([bool](Get-Command $c -ErrorAction SilentlyContinue)) "cmd $c" }
foreach ($r in $M.repos) {
  S (Test-Path (Join-Path $Root "repos\$($r.dir)\.git")) "repo $($r.id)"
  foreach ($s in $r.skills) { S (Test-Path (Join-Path $skills "$($s.name)\SKILL.md")) "  skill $($s.name)" }
}
S (Test-Path (Join-Path $skills 'motion-graphics-pbt\SKILL.md')) 'skill motion-graphics-pbt'
S (Test-Path (Join-Path $skills 'hyperframes\SKILL.md')) 'skill hyperframes (npx hyperframes skills update)'
S (Test-Path (Join-Path $Root 'libs\web3d\node_modules\three')) 'lib three / R3F'
S (Test-Path (Join-Path $Root 'libs\web3d\node_modules\@react-three\rapier')) 'lib @react-three/rapier'
S (Test-Path (Join-Path $Root 'libs\web3d\node_modules\@react-three\postprocessing')) 'lib @react-three/postprocessing'
$py = Join-Path $Root 'libs\py\Scripts\python.exe'
S ((Test-Path $py) -and ((& $py -c "import librosa;print('ok')" 2>$null) -eq 'ok')) 'python libs (librosa)'
S ([bool]$env:LEMO_OPUSCAR_HOME) "LEMO_OPUSCAR_HOME=$env:LEMO_OPUSCAR_HOME"
S (Test-Path (Join-Path $Root 'repos\claude-video-effects\.venv')) 'effects venv'
S (Test-Path (Join-Path $Root 'repos\ACE-Step-1.5\.venv')) 'ACE-Step venv (heavy)'
S (Test-Path (Join-Path $Root 'repos\OpenMontage\.venv')) 'OpenMontage venv (heavy)'
Write-Host "`nPendientes: $bad. Reparar: pwsh -File $(Join-Path $Root 'skill\install.ps1')"
