# motion-graphics-pbt - instalador
# Instala todos los repos, skills, librerias y dependencias del kit de motion graphics.
# Idempotente: se puede correr de nuevo para reparar o actualizar (-Update hace git pull).
# Uso:
#   pwsh -ExecutionPolicy Bypass -File install.ps1                 # todo
#   pwsh -ExecutionPolicy Bypass -File install.ps1 -SkipHeavy      # sin ACE-Step, OpenMontage deps, Blender
#   pwsh -ExecutionPolicy Bypass -File install.ps1 -Only lemo-opuscar,earshot
#   pwsh -ExecutionPolicy Bypass -File install.ps1 -Update
param(
  [string]$Root = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'motion-graphics'),
  [switch]$SkipHeavy,
  [switch]$Update,
  [string[]]$Only = @(),
  [switch]$NoWinget
)

$Only = @($Only | ForEach-Object { $_ -split ',' } | Where-Object { $_ })
$ErrorActionPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $here 'manifest.json'
if (-not (Test-Path $manifestPath)) { Write-Host "[X] No encuentro manifest.json junto a install.ps1 ($here)" -ForegroundColor Red; exit 1 }
$M = Get-Content $manifestPath -Raw | ConvertFrom-Json

$Repos   = Join-Path $Root 'repos'
$Libs    = Join-Path $Root 'libs'
$SkillDst = Join-Path $Root 'skill'
$Logs    = Join-Path $Root 'logs'
$ClaudeSkills = Join-Path $HOME '.claude\skills'
foreach ($d in @($Root, $Repos, $Libs, $Logs, $ClaudeSkills, (Join-Path $Root 'projects'))) { New-Item -ItemType Directory -Force $d | Out-Null }
$LogFile = Join-Path $Logs ("install-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')
$Report = [ordered]@{}

function Log([string]$msg, [string]$color = 'Gray') { Write-Host $msg -ForegroundColor $color; Add-Content -Path $LogFile -Value $msg }
function Ok($k, $v) { $Report[$k] = "OK $v"; Log "[OK] $k $v" 'Green' }
function Warn($k, $v) { $Report[$k] = "WARN $v"; Log "[!] $k $v" 'Yellow' }
function Fail($k, $v) { $Report[$k] = "FAIL $v"; Log "[X] $k $v" 'Red' }
function Want($id) { return ($Only.Count -eq 0) -or ($Only -contains $id) }
function Refresh-Path { $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + (Join-Path $HOME '.local\bin') + ';' + (Join-Path $HOME '.bun\bin') + ';' + (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps') }
function Run([string]$key, [string]$dir, [scriptblock]$block) {
  Push-Location $dir
  $global:LASTEXITCODE = 0
  Log "-> $key" 'Cyan'
  try {
    $out = & $block 2>&1
    $out | ForEach-Object { Add-Content -Path $LogFile -Value ("    " + $_) }
    if ($LASTEXITCODE -and $LASTEXITCODE -ne 0) { Fail $key "exit $LASTEXITCODE (ver $LogFile)" } else { Ok $key '' }
  } catch { Fail $key $_.Exception.Message } finally { Pop-Location }
}

Log "== motion-graphics-pbt installer  Root=$Root" 'Cyan'

# ---------- 0. copiar la skill a <Root>\skill si se corre desde otro lugar ----------
$hereFull = (Resolve-Path $here).Path.TrimEnd('\')
if ($hereFull -ne (Join-Path $Root 'skill')) {
  New-Item -ItemType Directory -Force $SkillDst | Out-Null
  Get-ChildItem $here -Force | Where-Object { $_.Name -ne '.git' } | Copy-Item -Destination $SkillDst -Recurse -Force
  Ok 'skill-copy' "-> $SkillDst"
}

# ---------- 1. prerrequisitos ----------
Refresh-Path
if (-not $NoWinget) {
  foreach ($w in $M.winget) {
    if (Get-Command $w.cmd -ErrorAction SilentlyContinue) { Ok "prereq-$($w.cmd)" 'presente'; continue }
    Log "-> instalando $($w.id) con winget" 'Cyan'
    winget install --id $w.id -e --accept-source-agreements --accept-package-agreements --silent 2>&1 | Out-Null
    Refresh-Path
    if (Get-Command $w.cmd -ErrorAction SilentlyContinue) { Ok "prereq-$($w.cmd)" 'instalado' } else { Warn "prereq-$($w.cmd)" "no quedo en PATH; abre otra terminal y reintenta" }
  }
}
if (-not (Get-Command jq -ErrorAction SilentlyContinue)) {
  $lb = Join-Path $HOME '.local\bin'; New-Item -ItemType Directory -Force $lb | Out-Null
  try { Invoke-WebRequest 'https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe' -OutFile (Join-Path $lb 'jq.exe') -TimeoutSec 120; Refresh-Path; Ok 'prereq-jq' 'descargado a ~/.local/bin' } catch { Warn 'prereq-jq' $_.Exception.Message }
}$GitBash = @("$env:ProgramFiles\Git\bin\bash.exe", "${env:ProgramFiles(x86)}\Git\bin\bash.exe", "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $GitBash) { Fail 'git-bash' 'no encontrado; varios setup.sh lo necesitan' } else { Ok 'git-bash' $GitBash }
$nodeMajor = 0; try { $nodeMajor = [int]((node --version).TrimStart('v').Split('.')[0]) } catch {}
if ($nodeMajor -lt 22) { Warn 'node-version' "Node $nodeMajor; HyperFrames y huashu-motion piden 22+" } else { Ok 'node-version' "v$nodeMajor" }
$chrome = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($chrome) { Ok 'chrome' $chrome } elseif (-not $NoWinget) { winget install --id Google.Chrome -e --silent --accept-source-agreements --accept-package-agreements 2>&1 | Out-Null; Warn 'chrome' 'instalado via winget (verificar)' }

function Bash([string]$cmd) { & $GitBash -lc $cmd }
function ToBashPath([string]$p) { $p = $p -replace '\\', '/'; if ($p -match '^([A-Za-z]):/(.*)$') { return '/' + $Matches[1].ToLower() + '/' + $Matches[2] } return $p }

# ---------- 2. clonar / actualizar repos ----------
foreach ($r in $M.repos) {
  if (-not (Want $r.id)) { continue }
  $dst = Join-Path $Repos $r.dir
  if (Test-Path (Join-Path $dst '.git')) {
    if ($Update) { Run "pull-$($r.id)" $dst { git pull --ff-only } } else { Ok "repo-$($r.id)" 'ya clonado' }
    continue
  }
  Log "-> clonando $($r.url)" 'Cyan'
  if ($r.sparse) {
    git clone --depth 1 --filter=blob:none --sparse $r.url $dst 2>&1 | Add-Content $LogFile
    Push-Location $dst; git sparse-checkout set --no-cone @($r.sparse) 2>&1 | Add-Content $LogFile; Pop-Location
  } else {
    git clone --depth 1 $r.url $dst 2>&1 | Add-Content $LogFile
  }
  if (Test-Path (Join-Path $dst '.git')) { Ok "repo-$($r.id)" 'clonado' } else { Fail "repo-$($r.id)" "git clone fallo: $($r.url)" }
}

# ---------- 3. registrar skills (junctions en ~/.claude/skills) ----------
function Link-Skill([string]$name, [string]$target) {
  $link = Join-Path $ClaudeSkills $name
  if (-not (Test-Path (Join-Path $target 'SKILL.md'))) { Fail "skill-$name" "sin SKILL.md en $target"; return }
  if (Test-Path $link) {
    $it = Get-Item $link -Force
    if ($it.LinkType -eq 'Junction' -or $it.LinkType -eq 'SymbolicLink') {
      if ((@($it.Target)[0]).TrimEnd('\') -eq $target.TrimEnd('\')) { Ok "skill-$name" 'ya enlazada'; return }
      cmd /c rmdir "$link" | Out-Null
    } else { Warn "skill-$name" "existe una carpeta real en $link; no la toco"; return }
  }
  cmd /c mklink /J "$link" "$target" | Out-Null
  if (Test-Path (Join-Path $link 'SKILL.md')) { Ok "skill-$name" "-> $target" } else { Fail "skill-$name" 'mklink fallo' }
}
foreach ($r in $M.repos) {
  if (-not (Want $r.id)) { continue }
  foreach ($s in $r.skills) { Link-Skill $s.name (((Join-Path (Join-Path $Repos $r.dir) $s.path) -replace '/', '\') -replace '\\\.$', '') }
}
if (Want 'self') { Link-Skill 'motion-graphics-pbt' $SkillDst }

# ---------- 4. librerias compartidas ----------
if (Want 'libs') {
  $web = Join-Path $Libs 'web3d'; New-Item -ItemType Directory -Force $web | Out-Null
  if (-not (Test-Path (Join-Path $web 'package.json'))) { Push-Location $web; npm init -y 2>&1 | Out-Null; Pop-Location }
  $pkgs = @($M.libs.web3d)
  Run 'libs-web3d' $web { npm install --no-fund --no-audit @pkgs }
  $py = Join-Path $Libs 'py'
  if (-not (Test-Path (Join-Path $py 'Scripts\python.exe'))) { Run 'libs-py-venv' $Libs { uv venv --python $M.libs.python.version py } }
  $pyexe = Join-Path $py 'Scripts\python.exe'
  $ppk = @($M.libs.python.packages)
  Run 'libs-py-packages' $Libs { uv pip install --python $pyexe @ppk }
  Run 'libs-py-playwright' $Libs { & $pyexe -m playwright install chromium }
  [Environment]::SetEnvironmentVariable('MG_PY', $pyexe, 'User'); $env:MG_PY = $pyexe
  [Environment]::SetEnvironmentVariable('MG_ROOT', $Root, 'User'); $env:MG_ROOT = $Root
  Ok 'env-vars' "MG_ROOT=$Root  MG_PY=$pyexe"
}

# ---------- 5. setup por repo ----------
foreach ($r in $M.repos) {
  if (-not (Want $r.id)) { continue }
  if ($r.heavy -and $SkipHeavy) { Warn "setup-$($r.id)" 'omitido (-SkipHeavy)'; continue }
  $dir = Join-Path $Repos $r.dir
  if (-not (Test-Path $dir)) { continue }
  foreach ($step in @($r.setup)) {
    switch ($step) {
      'npm-install' { Run "setup-$($r.id)-npm" $dir { npm install --no-fund --no-audit } }
      'hyperframes-skills' { Run 'setup-hyperframes-skills' $dir { npx --yes hyperframes@latest skills update } }
      'lemo-opuscar' {
        [Environment]::SetEnvironmentVariable('LEMO_OPUSCAR_HOME', $dir, 'User'); $env:LEMO_OPUSCAR_HOME = $dir
        $bp = ToBashPath $dir
        Run 'setup-lemo-opuscar' $dir { Bash "export LEMO_OPUSCAR_HOME='$bp'; cd '$bp' && sh plugin/skills/lemo-opuscar/scripts/setup.sh deps" }
      }
      'earshot' { Run 'setup-earshot' $dir { uv tool install --force --python 3.12 "earshot[mcp] @ $dir" } }
      'explainroo' { Run 'setup-explainroo-npm' $dir { npm install --no-fund --no-audit }; Run 'setup-explainroo' $dir { node bin/explainroo.js doctor --fetch } }
      'reanimate' { Run 'bun-upgrade' $dir { bun upgrade }; Refresh-Path; $bp = ToBashPath (Join-Path $dir 'skills\reanimate'); Run 'setup-reanimate' $dir { Bash "bash '$bp/scripts/setup.sh'" } }
      'video-effects' { Run 'setup-video-effects-venv' $dir { uv venv --allow-existing --python 3.12 .venv }; Run 'setup-video-effects-pip' $dir { uv pip install --python .venv\Scripts\python.exe -r requirements.txt }; if (-not (Test-Path (Join-Path $dir '.venv\bin'))) { cmd /c mklink /J "$(Join-Path $dir '.venv\bin')" "$(Join-Path $dir '.venv\Scripts')" | Out-Null } }
      'openmontage' {
        Run 'setup-openmontage-venv' $dir { uv venv --allow-existing --python 3.12 .venv }
        Run 'setup-openmontage-pip' $dir { uv pip install --python .venv\Scripts\python.exe -r requirements.txt }
        Run 'setup-openmontage-remotion' (Join-Path $dir 'remotion-composer') { npm install --no-fund --no-audit }
      }
      'ace-step' { Run 'setup-ace-step' $dir { uv sync } }
      'blender-mcp' {
        # Blender portable (sin admin) en <Root>\tools; el setup automatico de mcp-for-blender es interactivo, se usan los pasos manuales
        $tools = Join-Path $Root 'tools'; New-Item -ItemType Directory -Force $tools | Out-Null
        $bexe = Get-ChildItem $tools -Recurse -Depth 2 -Filter blender.exe -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $bexe) {
          $ver = $M.blender.version; $zip = Join-Path $tools 'blender.zip'
          Run 'blender-download' $tools { curl.exe -L -s -o $zip "https://download.blender.org/release/Blender$($ver.Substring(0, $ver.LastIndexOf('.')))/blender-$ver-windows-x64.zip" }
          Run 'blender-unzip' $tools { tar -xf $zip -C $tools }
          $bexe = Get-ChildItem $tools -Recurse -Depth 2 -Filter blender.exe -ErrorAction SilentlyContinue | Select-Object -First 1
        }
        if (-not $bexe) { Fail 'blender' 'no se pudo instalar Blender portable' } else {
          Ok 'blender' $bexe.FullName
          [Environment]::SetEnvironmentVariable('MG_BLENDER', $bexe.FullName, 'User'); $env:MG_BLENDER = $bexe.FullName
          $mm = ((& $bexe.FullName --version 2>$null | Select-Object -First 1) -replace '^Blender\s+(\d+\.\d+).*$', '$1')
          $ad = Join-Path $env:APPDATA "Blender Foundation\Blender\$mm\scripts\addons"; New-Item -ItemType Directory -Force $ad | Out-Null
          $env:PYTHONIOENCODING = 'utf-8'
          Run 'setup-blender-addon' $dir { uvx mcp-for-blender install-addon --addons-dir $ad }
          Run 'setup-blender-enable' $dir { & $bexe.FullName -b --python-expr "import bpy, addon_utils; addon_utils.enable('blender_mcp', default_set=True, persistent=True); bpy.ops.wm.save_userpref()" }
        }
        if (Get-Command claude -ErrorAction SilentlyContinue) {
          if (-not ((claude mcp list 2>&1) -match '^blender:')) { Run 'setup-blender-mcp-claude' $dir { claude mcp add --scope user blender uvx mcp-for-blender } } else { Ok 'setup-blender-mcp-claude' 'ya registrado' }
        } else { Warn 'setup-blender-mcp-claude' 'claude CLI no encontrado; correr: claude mcp add --scope user blender uvx mcp-for-blender' }
      }
      default { }
    }
  }
}

# ---------- 6. reporte ----------
$Report | ConvertTo-Json | Out-File -Encoding utf8 (Join-Path $Root 'install-report.json')
$fails = @($Report.GetEnumerator() | Where-Object { $_.Value -like 'FAIL*' })
$warns = @($Report.GetEnumerator() | Where-Object { $_.Value -like 'WARN*' })
Log "" ; Log "== Resumen: $($Report.Count) pasos, $($fails.Count) fallos, $($warns.Count) avisos. Log: $LogFile" 'Cyan'
$fails | ForEach-Object { Log ("   FAIL " + $_.Key + ": " + $_.Value) 'Red' }
Log "Listo. Reinicia Claude Code para que cargue las skills nuevas." 'Cyan'
Log "INSTALL-FINISHED" 'Cyan'






