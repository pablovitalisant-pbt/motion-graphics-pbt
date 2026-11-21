# Catálogo del kit (rutas relativas a %MG_ROOT%\repos)

Antes de usar una herramienta: leer su SKILL.md (columna "SKILL.md") y seguir su flujo. Lo de abajo es solo para elegir y arrancar.

## Motores de video

### HyperFrames — `hyperframes\` (sparse: docs + skills) · skills globales `/hyperframes`, `/hyperframes-cli`, `/hyperframes-registry`, `/media-use`, `/reverse-any-video`, `/style-sampling`
- HTML + GSAP → MP4 determinista (Chrome headless + FFmpeg). Node 22+.
- `npx hyperframes init <proj>` · `npx hyperframes preview` · `npx hyperframes render` · `npx hyperframes add <bloque>` (p.ej. `flash-through-white`, `instagram-follow`, `data-chart`).
- Úsalo como render de: video-director, three.js/R3F, beats de librosa, piezas sueltas.
- Actualizar skills: `npx hyperframes skills update`.

### huashu-motion — SKILL.md `huashu-motion\skills\huashu-motion\SKILL.md`
- Launch films / explainers comerciales; el director elige el lenguaje de movimiento; "señalar el frame" en un studio local para editar; compone música con pack de instrumentos reales.
- CLI: `node <repo>\cli\om.js` (o `npx huashu-motion`): `om check | still | look | sound | render | studio`, `om samples build` (una vez), `om fonts`.
- Usa el Chrome instalado. Node 22+.

### onetake — SKILL.md `onetake\SKILL.md`
- Un solo plano continuo (sin cortes), oráculo de continuidad, looks (`scripts/look.py sheet`).
- Python: usar `%MG_PY%` en lugar de `python3`. Render draft `scripts/render.py comp.html --out draft.mp4`, final `--final` (4K60, lento).

### Bart motion-graphics — `motion-graphics-bart\skills\*`
- `explainer-high-energy` 12–20 s hype; `explainer-default` 45–90 s demo con UI; `explainer-engaging` 10–30 s one-take.
- Patrón: HTML con `window.seek(t)` puro + `render.mjs` (Playwright). Stills → draft 30 fps → final 60 fps con motion blur.
- `motion-broll`, `object-separation`, `sound-effects`: ver Capas.

### video-shotcraft — SKILL.md `video-shotcraft\SKILL.md` (en chino; 124 recetas de planos)
- Promos cinematográficos desde un frontend/web real con Remotion + capturas reales, plantilla Ink Press, beat sync, búsqueda/alineación de SFX.
- Workbench: `node workbench\scripts\open.mjs <proyecto>` (puerto 5198).

### argo — SKILL.md `argo\skills\argo-guide\SKILL.md`
- Demo de web app real: script Playwright `*.demo.ts` + `*.scenes.json` → voz (kokoro-js local u OpenAI) → overlays → MP4.
- Por proyecto: `npm i -D @argo-video/cli kokoro-js` · `npx argo init` · `npx argo pipeline <demo>`.

### explainroo — SKILL.md `explainroo\skills\explainroo\SKILL.md`
- Explainer con voz en off local (Kokoro), subtítulos, diagramas; sin API key. `npx --yes explainroo ...`; docs: `npx --yes explainroo docs <tema>`; chequeo: `npx --yes explainroo doctor --language es`.

### video-director — SKILL.md `video-director\video-director\SKILL.md`
- Metodología con gates: brief → `timeline.json` → build (HTML/Canvas/SVG/Three/GSAP/Remotion) → render → `scripts/qa_video.py film.mp4 --out qa/ --beats timeline.json`. Úsalo como capa de dirección/QA sobre cualquier motor HTML.

### lemo-opuscar — SKILL.md `lemo-opuscar\plugin\skills\lemo-opuscar\SKILL.md` · librería `%LEMO_OPUSCAR_HOME%`
- ~100 estilos en `styles\<slug>\STYLE.md` (ink-wash, ukiyoe, pixel-rpg, newsreel, silent-film, whiteboard, satellite-briefing, teardown, risograph, neon-tubes, spy-titles, transit-map, …). Elegir slug, leer su STYLE.md.
- Herramientas: `cd %LEMO_OPUSCAR_HOME% && node core/render/still.mjs "<proyecto>" 1.5 3`. Voz/música opcionales: `sh plugin/skills/lemo-opuscar/scripts/setup.sh deps voice music` (Git Bash).

### take-one — SKILL.md `take-one\SKILL.md`
- "Estudio de 12 roles": aprende la marca desde su web, propone ruta (código / imágenes realistas / video model) con precios, pide OK antes de gastar. Chequeo: `bash ~/.claude/skills/take-one/scripts/doctor.sh` (Git Bash). Probado solo en macOS.

### OpenMontage — `OpenMontage\` (pipelines: explainer, animation, avatar, cinematic, clip factory, documentary montage, hybrid, dub, podcast, screen demo, talking head)
- Trabaja DENTRO del repo (tiene sus propias `.claude\skills`): copiar a `projects\` o abrir Claude Code ahí. venv: `OpenMontage\.venv`. Sin keys: `make demo` / `render_demo.py`. Generativo requiere keys en `.env` (Pexels/Pixabay gratis; ElevenLabs, Kling, etc. de pago → gate humano antes de gastar).

### ClaudeAnimationBase — `ClaudeAnimationBase\`
- Cartoon pintado a mano (p5.js + p5.brush) con el personaje Clawd. Copiar el repo a `projects\<slug>\`, leer `ANIMATION_GUIDE.md`, render `node render.mjs --clip --out=out/video.mp4`; preview `studio.html`. Sin GPU: pedir sin fills de acuarela.

### rossark-motion-skill — SKILL.md `rossark-motion-skill\SKILL.md` + `MOTION.md`
- Da vida a SVG/ilustraciones/logos/mascotas (parpadeo, respiración, fuego, tela, agua…), 60 fps. Herramientas en `tools\` (`track_edges.py`, `sample_colors.py` para copiar movimiento de un video ref).

### pixelfx — SKILL.md `pixelfx\skills\pixelfx\SKILL.md`
- 244 efectos pixel art. Trabajar en `repos\pixelfx`: `node tools/list.mjs <palabras>`, `node tools/render.mjs fire/torch [--sheet]`, `node tools/new.mjs <cat>/<nombre>`.

### reanimate — SKILL.md `reanimate\skills\reanimate\SKILL.md`
- Clona una animación (URL, mp4, gif, Lottie) y verifica frame a frame. Requiere Bun. `bun <skill>/scripts/<x>.ts --help`. Windows no probado.

### 3D web — `%MG_ROOT%\libs\web3d\node_modules`
- three, @react-three/fiber, @react-three/drei, @react-three/rapier (físicas), @react-three/postprocessing + postprocessing (bloom, DOF, glitch, chromatic aberration), gsap.
- Para render determinista: escena controlada por tiempo (`seek(t)`), sin `requestAnimationFrame` libre; con rapier, avanzar el mundo con paso fijo `world.step()` por frame. Renderizar con HyperFrames o un `render.mjs` Playwright. Docs: threejs.org/docs, pmndrs.github.io/react-three-rapier.

### Blender MCP — `mcp-for-blender\`
- Blender portable en `%MG_ROOT%\tools\blender-*\blender.exe` (variable `%MG_BLENDER%`), addon `blender_mcp` ya habilitado, servidor MCP `blender` registrado en Claude Code (scope user).
- Uso: abrir Blender (`& $env:MG_BLENDER`); el addon arranca su servidor al abrir (panel N > MCP for Blender). Luego usar las herramientas MCP `blender`. Render sin UI: `& $env:MG_BLENDER -b escena.blend -o //frames/#### -a`. Integrar con ffmpeg.

### video-use — SKILL.md `%USERPROFILE%\.claude\skills\video-use\SKILL.md` (junction a `%USERPROFILE%\video-use`, repo browser-use/video-use; fuera de `repos\`, no lo instala `install.ps1`)
- Edición conversacional de footage: transcribe (faster-whisper local, sin API key), empaqueta `takes_packed.md`, decide cortes en límites de palabra, color grade, overlays animados (HyperFrames/Remotion/Manim por slot), subtítulos quemados, voiceover con voz clonada si `VU_VOZ_DIR` está configurado.
- Python: `%USERPROFILE%\video-use\.venv\Scripts\python.exe` + `helpers\transcribe.py`, `transcribe_batch.py`, `pack_transcripts.py`, `timeline_view.py`, `render.py`.
- Salidas SIEMPRE en `<carpeta de videos>\edit\` (nunca dentro de video-use). Reglas duras: subtítulos al final, concat `-c copy` por segmento, fades de 30 ms, nunca cortar dentro de una palabra, confirmar la estrategia antes de cortar.

### reverse-any-video — skill global `/reverse-any-video` (HyperFrames)
- Reconstruye un video completo como proyecto HyperFrames editable, verificado cuadro a cuadro (`npx hyperframes reverse start <video> --dir <proj>`, `npx hyperframes measure cuts`). Función HyperFrames **Pro** (pago): si la CLI la rechaza, informar y no correr `billing`. Solo videos que Pablo tenga derecho a usar.

### style-sampling — skill global `/style-sampling` (HyperFrames)
- Episodio nuevo en plantillas de serie: `collage-explainer`, `finance-explainer` (中文, voz y cara), `animated-science-explainer`, `3d-brand-explainer`, `3d-true-crime`. Función HyperFrames **Pro** (pago). Idioma según plantilla: confirmar en su SKILL.md antes de prometer español.

### media-use — skill global `/media-use` (HyperFrames)
- `npx hyperframes media-use resolve --type <bgm|sfx|image|logo|voice|video|cutout|...> --intent "..." --project <dir>` deja el archivo en `assets/` con registro. Gratis: catálogo HeyGen (con sesión), Openverse, `npx hyperframes tts` (Kokoro local), `npx hyperframes transcribe`. Generado = créditos → OK de Pablo.

### motion-design — SKILL.md `%USERPROFILE%\.claude\skills\motion-design\SKILL.md` (LottieFiles, no está en `repos\`)
- Principios: emoción objetivo, personalidad de movimiento, duraciones, easing (entrada desacelera, salida acelera), héroe + capas secundarias, regla de 1/3. Usar como checklist antes de animar con cualquier motor.

## Sonido y música

### earshot / real-sound — SKILL.md `earshot\skills\earshot\SKILL.md`, `earshot\skills\real-sound\SKILL.md`
- CLI `earshot` (uv tool, CPU): `earshot doctor`, escuchar/juzgar/comparar audio, `earshot sfx`/`kit` banco de SFX, `earshot forge`. Usar antes de afirmar cómo suena algo.

### ACE-Step 1.5 — `ACE-Step-1.5\` · skills `acestep`, `acestep-simplemv`
- Servidor local: `cd ACE-Step-1.5; $env:ACESTEP_INIT_LLM='false'; uv run acestep-api` (puerto 8001) o UI `uv run acestep` (7860). Modelos se descargan la primera vez.
- Sin GPU NVIDIA en este PC: CPU = muy lento; usar DiT-only, piezas cortas (≤30 s), o portable/otra máquina con GPU.
- Llamar SOLO vía `scripts/acestep.sh` (Git Bash; requiere curl + jq).

### librosa — `%MG_PY%` + `skill\scripts\beats.py`
- `%MG_PY% %MG_ROOT%\skill\scripts\beats.py musica.mp3 --out beats.json` → tempo, beats, downbeats aprox., onsets, curva de energía. Alimenta timeline de cortes.

### Openverse — `skill\scripts\openverse.ps1`
- `pwsh -File openverse.ps1 -Type audio -Query "whoosh" -License cc0 -Download -Out .\assets` → descarga + `CREDITS.txt` con atribución. Imágenes: `-Type images`. API anónima, rate-limited.

## Bibliotecas de prompts
- `awesome-opus5-5-videos\prompts\*.md` (703, uno por creador/video) + `data\videos.json`.
- `opus-video-prompts\prompts\*.md` (18 casos largos) + `cases.json` (54: category, title, author, how, cost, url).
- Buscar: `Select-String -Path <dir>\*.md -Pattern "kinetic|logo|chart" -List`. Adaptar, no copiar tal cual; dar crédito.

