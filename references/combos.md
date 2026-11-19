# Recetas de combinación

## Pipelines típicos

**Reel talking-head con gráficos (9:16)**
1. `effects` words.py o faster-whisper (`%MG_PY%`) → tiempos de palabras.
2. (opcional) `object-separation` → máscaras para poner gráficos detrás.
3. `effects` (1–2 efectos disparados por palabra) y/o `motion-broll` (cutaways).
4. `sound-effects` (SFX medidos) → `earshot` revisa mezcla y sync.

**Promo de producto desde cero (15–30 s)**
1. Ficha + guion corto. Música: ACE-Step (local) o `real-sound`; `beats.py` → grilla.
2. Motor: huashu-motion (comercial) / onetake (plano continuo) / explainer-high-energy (hype) / video-shotcraft (hay web real).
3. Inserto 3D opcional: R3F + postprocessing renderizado aparte → overlay.
4. `sound-effects` + `earshot`.

**Explainer educativo con voz (60–120 s)**
explainroo (voz local + diagramas) como base; intro/outro en un estilo lemo-opuscar; b-roll con imágenes Openverse; video-director `qa_video.py` como QA final.

**Video musical**
ACE-Step (canción) → `beats.py` → acestep-simplemv (lyric) o HyperFrames/lemo-opuscar con cortes en downbeats.

## ffmpeg (Windows, PowerShell)

```powershell
# Concatenar piezas con mismo codec/resolución
"file 'intro.mp4'`nfile 'body.mp4'`nfile 'outro.mp4'" | Set-Content list.txt -Encoding ascii
ffmpeg -y -f concat -safe 0 -i list.txt -c copy joined.mp4

# Normalizar una pieza a reel 1080x1920 30fps antes de concatenar
ffmpeg -y -i in.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,fps=30" -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -c:a aac -ar 48000 out.mp4

# Overlay con alfa (render con fondo transparente en .mov ProRes 4444 o .webm VP9) entre t=3 y t=6
ffmpeg -y -i base.mp4 -i overlay.mov -filter_complex "[0][1]overlay=0:0:enable='between(t,3,6)'" -c:a copy out.mp4

# Mezclar música bajo la voz con ducking y loudness final -16 LUFS
ffmpeg -y -i video.mp4 -i music.wav -filter_complex "[1:a]volume=0.35[m];[m][0:a]sidechaincompress=threshold=0.05:ratio=8[d];[0:a][d]amix=inputs=2:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k out.mp4

# Contact sheet para revisar (1 frame/seg, 5 columnas)
ffmpeg -y -i film.mp4 -vf "fps=1,scale=360:-1,tile=5x4" -frames:v 1 sheet.png

# Verificar
ffprobe -v error -show_entries format=duration:stream=width,height,r_frame_rate,codec_name -of compact film.mp4
```
