---
name: motion-graphics-pbt
description: Director de motion graphics y edición de video de Pablo. Usar PRIMERO ante cualquier pedido de video (editar footage grabado (cortes, color, subtítulos), video hecho con código, motion graphics, animación, reel, explainer, promo/launch film, b-roll animado, efectos sobre un talking-head, kinetic typography, video musical, pixel art, 3D o sonido/música para un video). Analiza el caso, elige la mejor skill o herramienta del kit instalado (video-use, HyperFrames y sus skills media-use/reverse-any-video/style-sampling, Lemo-Opuscar, huashu-motion, OneTake, Take One, video-director, explainroo, Argo, video-shotcraft, Bart motion-graphics, Claude Video Effects, rossark, reanimate, pixelfx, ClaudeAnimationBase, three.js/R3F, Blender MCP, earshot, ACE-Step, librosa, Openverse, OpenMontage, motion-design) y las combina en un mismo video cuando conviene; si dos opciones encajan, decide con evidencia (stills/draft comparados).
---

# Motion Graphics PBT — director y router

Kit instalado en `%MG_ROOT%` (por defecto `C:\Users\<user>\Documents\motion-graphics`):
`repos\` (clones), `libs\web3d` (three/R3F/rapier/postprocessing), `libs\py` (Python 3.12 con librosa, opencv, playwright, faster-whisper), `projects\` (donde se crean los videos), `skill\` (esta skill).
Si algo falta: `pwsh -File %MG_ROOT%\skill\install.ps1` (idempotente) o `-Only <id>`. Estado: `pwsh -File %MG_ROOT%\skill\scripts\doctor.ps1`.

## Si Claude corre en claude.ai (chat), no en Claude Code

- El kit vive en el PC de Pablo; el workspace en la nube no lo tiene. Ejecutar en el PC con la herramienta PowerShell de Windows-MCP (cargarla con ToolSearch si está diferida). Si no responde: pedir que la app de escritorio de Claude esté abierta y el PC encendido.
- Cargar las variables de usuario al inicio de cada comando: `foreach($v in 'MG_ROOT','MG_PY','LEMO_OPUSCAR_HOME','MG_BLENDER'){ $x=[Environment]::GetEnvironmentVariable($v,'User'); if($x){ Set-Item "env:$v" $x } }; if(-not $env:MG_BLENDER){ $env:MG_BLENDER=(Get-ChildItem "$env:MG_ROOT\tools" -Recurse -Depth 2 -Filter blender.exe | Select -First 1).FullName }`.
- Las SKILL.md del kit están en `%USERPROFILE%\.claude\skills\<nombre>\SKILL.md`: leerlas con `Get-Content -Raw -Encoding UTF8`. Los detalles de `references\` están en `%MG_ROOT%\skill\references\`.
- Timeout corto: renders, servidores e instalaciones largas se lanzan desacoplados (`Start-Process pwsh -WindowStyle Hidden ...` con salida a un log del proyecto) y se consulta el log.
- El MCP `blender` solo existe en Claude Code; desde el chat usar Blender en modo `-b` (sin UI).
- Las sub-agentes paralelas que pide video-use (animaciones) solo si la sesión tiene la herramienta Agent; si no, en secuencia.

## Procedimiento (siempre en este orden)

1. **Ficha del video** (deducir del pedido; preguntar solo lo bloqueante, una pregunta, en texto):
   - Input: ¿hay footage (talking-head, screen recording), una web/app real, un SVG/ilustración, un audio/canción, o nada?
   - Formato: 9:16 reel / 16:9 / 1:1; duración; idioma de voz.
   - Objetivo: promo/launch, explainer/tutorial, b-roll sobre narración, efecto sobre talking-head, video musical/lyric, estilo artístico, pixel/juego, 3D/físicas, clonar una animación vista.
   - Sonido: ¿voz en off (local Kokoro/explainroo), música (ACE-Step local o licenciada), SFX?
   - Restricciones: costo (preferir 100% local, sin API keys), tiempo de render (este PC no tiene GPU dedicada: evitar watercolor p5.brush pesado, ACE-Step en CPU es lento).
   - Gasto: cualquier herramienta de pago (HyperFrames Pro: reverse-any-video y style-sampling; créditos HyperFrames/HeyGen en media-use; take-one; APIs de pago de OpenMontage; GEMINI_API_KEY de gbro) requiere OK explícito de Pablo antes de usarla. Ofrecer siempre la alternativa local.
2. **Elegir motor principal** con la tabla de abajo. Un video = un motor principal que produce el MP4 base.
   - Si hay footage grabado que haya que cortar/limpiar, el motor es **video-use** y todo lo demás son capas.
   - **Elección con evidencia**: si la tabla deja 2 candidatos razonables (p. ej. huashu-motion vs explainer-high-energy, explainroo vs video-director+HyperFrames, reanimate vs reverse-any-video), producir con cada uno el mismo momento clave (1–3 stills o un draft ≤5 s, sin render final), mirarlos lado a lado y elegir; mostrar la comparación a Pablo en 2 líneas. Si solo hay un candidato claro, no comparar.
   - La tabla es una guía escrita sin pruebas sistemáticas en este PC: si una herramienta falla dos veces en Windows, pasar al segundo candidato y anotarlo.
3. **Elegir capas** (opcionales) que se aplican antes o después del motor: efectos sobre footage, b-roll, sonido, música, assets.
4. **Leer la SKILL.md de cada herramienta elegida** (ruta en `references/catalog.md`) y seguir SU flujo. No improvisar comandos: el catálogo y la SKILL.md de cada repo mandan.
5. **Crear el proyecto** en `%MG_ROOT%\projects\<yyyy-mm-dd>-<slug>\` (nunca dentro de `repos\`, salvo OpenMontage y ClaudeAnimationBase que trabajan dentro de su repo: copiar el repo a projects\ primero).
6. **Componer**: unir piezas con ffmpeg (ver `references/combos.md`: concat, overlay, mezcla de audio, loudness -16 LUFS).
7. **Verificar** antes de entregar: frames clave (stills/contact sheet), duración y resolución con ffprobe, audio escuchado con `earshot` cuando haya sonido. Entregar ruta del MP4 final.

## Tabla de decisión — motor principal

| Situación | Motor | Por qué |
|---|---|---|
| **Editar footage ya grabado** (talking-head, entrevista, tutorial, montaje, viaje): cortar muletillas, retomas y silencios, color, subtítulos, overlays animados, voz clonada | **video-use** | transcripción local por palabra (faster-whisper), cortes en límites de palabra, EDL, render con ffmpeg; confirma la estrategia con Pablo antes de cortar |
| **Episodio en un estilo de serie probado** (Collage Explainer, Finance Explainer, Animated Science Explainer, 3D Brand Explainer, 3D True Crime) | **style-sampling** (HyperFrames Pro, pago → OK de Pablo) | estructura, ritmo y look de la serie sobre un tema nuevo; nunca usa cara/voz/marca del creador |
| Promo/launch de producto o SaaS, look comercial, iterar "señalando el frame" | **huashu-motion** | director de lenguaje de movimiento + estudio para editar frames; compone música |
| Launch film en **un solo plano continuo** sin cortes | **onetake** | cámara continua con oráculo de continuidad; looks predefinidos |
| Promo 12–20 s hype, kinetic type, beat-locked | **explainer-high-energy** (Bart) | |
| Demo de producto 45–90 s con la UI reconstruida | **explainer-default** (Bart) o **video-shotcraft** si hay frontend/web real que capturar (Remotion, 124 recetas de planos) | |
| Explainer 10–30 s one-take, un elemento viaja por el flujo | **explainer-engaging** (Bart) | |
| Demo grabando una **web app real** con Playwright + voz IA | **argo** | |
| Explainer/tutorial con **voz en off local** (sin API key), diagramas animados, shorts | **explainroo** | Kokoro local, subtítulos, español soportado |
| Film en un **estilo artístico nombrado** (ink wash, ukiyo-e, pixel RPG, newsreel, whiteboard, satellite briefing… ~100 estilos) | **lemo-opuscar** | elegir estilo de `repos\lemo-opuscar\styles\` |
| Pedido de video genérico/mixto, o se necesita storyboard + gates de calidad + verificación | **video-director** (metodología) + **HyperFrames** como render | |
| HTML→MP4 directo, plantillas del registry (transiciones shader, overlays sociales, charts) | **HyperFrames** (`/hyperframes`) | base de muchos otros |
| Campaña completa "estudio" (estrategia, guion, voz, música, review, copy) con presupuesto | **take-one** | pide aprobación antes de gastar en APIs |
| Pipeline de producción grande (clip factory, podcast→video, documental de stock, dub) | **OpenMontage** | requiere API keys para lo generativo; `make demo` es sin keys |
| Cartoon pintado a mano / acuarela con personaje | **ClaudeAnimationBase** (p5.brush) | lento sin GPU: pedir fills planos |
| Animar un **SVG/ilustración/logo/mascota** con movimiento creíble | **rossark-motion-skill** | |
| Pixel art VFX / sprites / juego | **pixelfx** | 244 efectos |
| 3D, físicas, partículas, post-processing (bloom, DOF, glitch) | **three.js + @react-three/rapier + @react-three/postprocessing** desde `libs\web3d`, renderizado por HyperFrames o Remotion | |
| Modelado/render 3D real (escenas, productos, cámaras) | **Blender MCP** (Blender abierto + addon) → exportar secuencia/MP4 | |
| Video musical / lyric video desde audio + letra | **acestep-simplemv** (Remotion) o HyperFrames + beats de librosa | |
| Clonar una **animación, sección o widget** (web, gif, Lottie, grabación) | **reanimate** (verifica frame a frame) | sale código animado; local, gratis |
| Rehacer **un video completo** como proyecto HyperFrames editable, igual cuadro a cuadro | **reverse-any-video** (HyperFrames Pro, pago → OK de Pablo) | mide cortes y reconstruye cada plano; si no hay Pro: reanimate por secciones + video-director |

## Capas (combinables con cualquier motor)

| Necesidad | Herramienta |
|---|---|
| Criterio de movimiento: timing, easing, coreografía, principios Disney, personalidad de marca | **motion-design** (LottieFiles) — consultar al diseñar cualquier animación, antes de escribirla |
| Conseguir/generar media para un proyecto HyperFrames: música, SFX, imágenes, íconos, logos, voz (Kokoro local), transcripción, recortes, color grade de footage oscuro/plano | **media-use** (`npx hyperframes media-use resolve`; lo gratis/local primero, créditos HeyGen/HyperFrames solo con OK) |
| Efectos sobre **talking-head ya grabado** (orbit, spotlight, glass widgets, headline match-cut, checklist… 51, disparables por palabra) | **effects** (Claude Video Effects) |
| B-roll de motion graphics sincronizado a las palabras del speaker | **motion-broll** (Bart) |
| Recortar persona/producto del fondo (SAM 2) para poner gráficos detrás | **object-separation** (Bart) |
| B-roll estilo collage de papel halftone | **gbro-collage-broll** (requiere GEMINI_API_KEY; su gate de imagen está pensado para Codex: en Claude generar el still por otra vía) |
| SFX medidos, cortes al beat, mezcla -16 LUFS | **sound-effects** (Bart) |
| Banda sonora con grabaciones reales licenciadas, foley, risers | **real-sound** (earshot) |
| **Escuchar** y juzgar audio (elegir SFX, revisar sync y mezcla) | **earshot** — usar SIEMPRE antes de afirmar cómo suena algo |
| Música original local (texto→canción/instrumental) | **acestep** (servidor local; CPU = lento, usar DiT-only, `ACESTEP_INIT_LLM=false`) |
| Grilla de beats/onsets/energía para sincronizar cortes | `scripts\beats.py` (librosa) |
| Imágenes/audio CC libres con atribución | `scripts\openverse.ps1` (Openverse API) |
| Ideas y prompts probados | `repos\awesome-opus5-5-videos\prompts\` (703) y `repos\opus-video-prompts\prompts\` + `cases.json` (54) — buscar por tema con grep y adaptar, citando al creador |

## Reglas de combinación

- Un motor principal por pieza; varias piezas se concatenan (p. ej. intro lemo-opuscar 5 s + cuerpo explainroo + cierre huashu).
- Talking-head / footage grabado: video-use (corte base + color, SIN quemar subtítulos todavía; sus transcripts por palabra sirven de tiempos) → object-separation (si hay gráficos detrás) → effects / motion-broll → sound-effects → subtítulos al final (regla de video-use: siempre últimos en la cadena) → mezcla final.
- Generado desde cero: motor → (opcional) música ACE-Step o real-sound → sound-effects → earshot review.
- Sincronía: obtener tiempos de palabras (`effects` words.py o faster-whisper en `%MG_PY%`) y beats (`beats.py`) ANTES de animar; pasarlos como datos al motor.
- 1–2 efectos por reel, no siete. Formato reel por defecto: 1080×1920, 30 fps, H.264 yuv420p, `-preset veryfast`.
- Audio de terceros solo con licencia (Openverse CC0/CC-BY con atribución, bancos CC0 de los repos, o ACE-Step propio).

## Notas Windows (este PC)

- `python3` en las SKILL.md de los repos → usar `%MG_PY%` (Python 3.12 del kit). Scripts `.sh` → `"C:\Program Files\Git\bin\bash.exe" -lc "..."`.
- Rutas `~/.claude/skills/<x>` que citan los repos existen como junctions a `repos\`.
- take-one y reanimate declaran "probado en macOS/Linux": en Windows correr con Git Bash/Bun y verificar cada paso.
- Sin GPU dedicada: renders WebGL/p5.brush lentos; preferir HTML/SVG/Canvas 2D y previsualizar con stills antes del render completo.

Detalle por herramienta (rutas, comandos de arranque, requisitos): `references/catalog.md`. Recetas de composición con ffmpeg: `references/combos.md`.
