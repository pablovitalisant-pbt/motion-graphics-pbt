"""Grilla de ritmo para sincronizar motion graphics.
Uso: %MG_PY% beats.py <audio> [--out beats.json] [--hop 512]
Salida JSON: duration, tempo, beats[], downbeats[] (cada 4 beats, aproximado), onsets[], energy[{t,rms}] (10 por segundo).
"""
import argparse, json, sys

import librosa
import numpy as np


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("audio")
    ap.add_argument("--out", default=None)
    ap.add_argument("--hop", type=int, default=512)
    a = ap.parse_args()

    y, sr = librosa.load(a.audio, sr=22050, mono=True)
    dur = float(librosa.get_duration(y=y, sr=sr))
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr, hop_length=a.hop)
    beats = librosa.frames_to_time(beat_frames, sr=sr, hop_length=a.hop).tolist()
    onset_frames = librosa.onset.onset_detect(y=y, sr=sr, hop_length=a.hop, backtrack=True)
    onsets = librosa.frames_to_time(onset_frames, sr=sr, hop_length=a.hop).tolist()

    # downbeat aproximado: fase de 4 con mayor energia de onset
    env = librosa.onset.onset_strength(y=y, sr=sr, hop_length=a.hop)
    best, phase = -1.0, 0
    for p in range(4):
        fr = beat_frames[p::4]
        s = float(env[fr].sum()) if len(fr) else 0.0
        if s > best:
            best, phase = s, p
    downbeats = beats[phase::4]

    hop10 = max(1, sr // 10)
    rms = librosa.feature.rms(y=y, frame_length=hop10 * 2, hop_length=hop10)[0]
    rms = rms / (rms.max() or 1.0)
    energy = [{"t": round(i / 10, 2), "rms": round(float(v), 3)} for i, v in enumerate(rms)]

    out = {
        "audio": a.audio,
        "duration": round(dur, 3),
        "tempo": round(float(np.atleast_1d(tempo)[0]), 2),
        "beats": [round(t, 3) for t in beats],
        "downbeats": [round(t, 3) for t in downbeats],
        "onsets": [round(t, 3) for t in onsets],
        "energy": energy,
    }
    txt = json.dumps(out, indent=1)
    if a.out:
        with open(a.out, "w", encoding="utf-8") as f:
            f.write(txt)
        print(f"ok tempo={out['tempo']} beats={len(beats)} onsets={len(onsets)} -> {a.out}")
    else:
        sys.stdout.write(txt)


if __name__ == "__main__":
    main()
