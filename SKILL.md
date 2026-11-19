---
name: motion-graphics-pbt
description: Director de motion graphics de Pablo. Usar PRIMERO ante cualquier pedido de video hecho con código, motion graphics, animación, reel, explainer, promo/launch film, b-roll animado, efectos sobre un talking-head, kinetic typography, video musical, pixel art, 3D o sonido/música para un video. Analiza el caso, elige la mejor skill o herramienta del kit instalado en Documents\motion-graphics (HyperFrames, Lemo-Opuscar, huashu-motion, OneTake, Take One, video-director, explainroo, Argo, video-shotcraft, Bart motion-graphics, Claude Video Effects, rossark, reanimate, pixelfx, ClaudeAnimationBase, three.js/R3F, Blender MCP, earshot, ACE-Step, librosa, Openverse, OpenMontage) y las combina en un mismo video cuando conviene.
---

# Motion Graphics PBT — director y router

Kit instalado en `%MG_ROOT%` (por defecto `C:\Users\<user>\Documents\motion-graphics`):
`repos\` (clones), `libs\web3d` (three/R3F/rapier/postprocessing), `libs\py` (Python 3.12 con librosa, opencv, playwright, faster-whisper), `projects\` (donde se crean los videos), `skill\` (esta skill).
Si algo falta: `pwsh -File %MG_ROOT%\skill\install.ps1` (idempotente) o `-Only <id>`. Estado: `pwsh -File %MG_ROOT%\skill\scripts\doctor.ps1`.

## Procedimiento (siempre en este orden)

1. **Ficha del video** (deducir del pedido; preguntar solo lo bloqueante, una pregunta, en texto):
   - Input: ¿hay footage (talking-head, screen recording), una web/app real, un SVG/ilustración, un audio/canción, o nada?
   - Formato: 9:16 reel / 16:9 / 1:1; duración; idioma de voz.
   - Objetivo: promo/launch, explainer/tutorial, b-roll sobre narración, efecto sobre talking-head, video musical/lyric, estilo artístico, pixel/juego, 3D/físicas, clonar una animación vista.
   - Sonido: ¿voz en off (local Kokoro/explainroo), música (ACE-Step local o licenciada), SFX?
   - Restricciones: costo (preferir 100% local, sin API keys), tiempo de render (este PC no tiene GPU dedicada: evitar watercolor p5.brush pesado, ACE-Step en CPU es lento).
2. **Elegir motor principal** con la tabla de abajo. Un video = un motor principal que produce el MP4 base.
3. **Elegir capas** (opcionales) que se aplican antes o después del motor: efectos sobre footage, b-roll, sonido, música, assets.
4. **Leer la SKILL.md de cada herramienta elegida** (ruta en `references/catalog.md`) y seguir SU flujo. No improvisar comandos: el catálogo y la SKILL.md de cada repo mandan.
5. **Crear el proyecto** en `%MG_ROOT%\projects\<yyyy-mm-dd>-<slug>\` (nunca dentro de `repos\`, salvo OpenMontage y ClaudeAnimationBase que trabajan dentro de su repo: copiar el repo a projects\ primero).
6. **Componer**: unir piezas con ffmpeg (ver `references/combos.md`: concat, overlay, mezcla de audio, loudness -16 LUFS).
7. **Verificar** antes de entregar: frames clave (stills/contact sheet), duración y resolución con ffprobe, audio escuchado con `earshot` cuando haya sonido. Entregar ruta del MP4 final.

## Tabla de decisión — motor principal

| Situación | Motor | Por qué |
|---|---|---|
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
| Clonar/replicar una animación vista en una web o video | **reanimate** (verifica frame a frame) | |

## Capas (combinables con cualquier motor)

| Necesidad | Herramienta |
|---|---|
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
- Talking-head: orden recomendado = object-separation (si hay gráficos detrás) → effects / motion-broll → sound-effects → mezcla final.
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
