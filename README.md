# motion-graphics-pbt

Skill router para crear motion graphics con Claude Code. Elige y combina las herramientas del kit según el video (HyperFrames, Lemo-Opuscar, huashu-motion, OneTake, explainroo, Claude Video Effects, Blender MCP, ACE-Step, earshot, librosa, Openverse y más; lista completa en `manifest.json`).

## Instalar en un PC nuevo (Windows)

Requisitos mínimos: Windows 10/11, git y PowerShell 7 (`winget install Microsoft.PowerShell`). El resto (Node, uv, ffmpeg, Bun, jq, Python 3.12 vía uv, Blender portable) lo instala el script.

```powershell
git clone https://github.com/pablovitalisant-pbt/motion-graphics-pbt "$HOME\Documents\motion-graphics\skill"
pwsh -ExecutionPolicy Bypass -File "$HOME\Documents\motion-graphics\skill\install.ps1"
pwsh -File "$HOME\Documents\motion-graphics\skill\scripts\doctor.ps1"
```

Luego reiniciar Claude Code y usar `/motion-graphics-pbt <pedido del video>`.

Opciones de `install.ps1`:
- `-SkipHeavy` omite ACE-Step (torch + modelos), dependencias de OpenMontage y Blender.
- `-Only lemo-opuscar,earshot` instala solo esos ids (ver `manifest.json`).
- `-Update` hace `git pull` de todos los repos del kit.

Actualizar la skill misma: `git -C "$HOME\Documents\motion-graphics\skill" pull`.

Queda todo en `Documents\motion-graphics\` (repos, libs, tools, projects, logs, skill) y las skills enlazadas (junctions) en `~/.claude/skills`.
