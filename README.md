# ClipComplete Mobile — Android & iOS

> Die native Smartphone-App zu [ClipComplete](https://github.com/Thexmr/ai-video-studio).
> **Alle Features** des Studios auf dem Handy: Auto-Edit, Text-Schnitt (Descript-Style),
> Asset-Studio mit Vision, Motion-Graphics-Themes, Musikvideo-Abteil.

## Architektur (wichtig)

Die schweren KI-/Render-Schritte (Whisper-Transkription, ffmpeg, Remotion-Motion-Graphics)
laufen **auf dem Studio-Server** (dein PC oder ein Cloud-Server) — wie bei jedem
professionellen Video-KI-Tool. Die App ist der vollwertige Client:

```
Smartphone-App (diese Repo)  ←HTTP/WebSocket→  ClipComplete-Server (ai-video-studio)
  UI, Upload, Steuerung                          Whisper · LLM · ffmpeg · Remotion
```

Beim ersten Start fragt die App nach der Server-Adresse (z.B. `http://192.168.1.20:8000`)
und merkt sie sich. Die UI ist dieselbe responsive Codebasis wie das Studio —
ein Fix/Feature im Hauptrepo landet per `npm run sync` automatisch in der App.

## Voraussetzungen

| Ziel | Du brauchst |
|---|---|
| **Android (APK)** | Node 18+, [Android Studio](https://developer.android.com/studio) (SDK 34+) |
| **iOS** | macOS mit Xcode 15+ (Apple-Vorgabe — iOS-Apps lassen sich nur auf macOS bauen) |
| **Server** | Das Hauptrepo [`ai-video-studio`](https://github.com/Thexmr/ai-video-studio) installiert & gestartet |

## Android bauen (Schritt für Schritt)

```powershell
git clone https://github.com/Thexmr/ai-video-studio        # Server/Frontend (Schwester-Ordner)
git clone https://github.com/Thexmr/Clipcomplete-Mobil clipcomplete-mobile
cd clipcomplete-mobile
npm install
npm run sync          # baut das Frontend & kopiert es in die App, cap sync
npm run android       # oeffnet Android Studio -> Run ▶ oder Build > APK
```

Fertige APK: `android/app/build/outputs/apk/debug/app-debug.apk` — aufs Handy
kopieren und installieren (oder direkt per USB mit Run ▶).

## iOS bauen

```bash
npm install && npm run sync
npx cap add ios       # einmalig, auf macOS
npm run ios           # oeffnet Xcode -> Signing-Team waehlen -> Run ▶
```

## Server starten & verbinden

1. Auf dem PC: `ai-video-studio\start.bat` — **wichtig fuer Handy-Zugriff**: der
   Server muss im Netzwerk erreichbar sein, also mit
   `python -m uvicorn app.main:app --host 0.0.0.0 --port 8000` starten
   (oder start.bat entsprechend anpassen) und den Port 8000 in der
   Windows-Firewall freigeben.
2. PC-IP herausfinden: `ipconfig` → IPv4-Adresse (z.B. `192.168.1.20`).
3. App starten → `http://192.168.1.20:8000` eingeben → Verbinden.

Handy und PC muessen im selben WLAN sein (oder der Server oeffentlich/VPN erreichbar).

## Updates aus dem Hauptrepo uebernehmen

```powershell
cd ..\ai-video-studio && git pull
cd ..\clipcomplete-mobile
npm run sync          # neues Frontend in die App
```

Dann in Android Studio/Xcode neu bauen.

## Troubleshooting

- **"Mit Studio-Server verbinden" erscheint immer wieder** → Adresse falsch oder
  Server nicht mit `--host 0.0.0.0` gestartet / Firewall blockt Port 8000.
- **Uploads schlagen fehl** → gleiche Ursache; im Browser am Handy
  `http://<PC-IP>:8000/health` testen — muss `{"status":"ok"}` zeigen.
- **HTTP statt HTTPS** → fuer das Heimnetz ist `cleartext: true` gesetzt; fuer
  einen oeffentlichen Server HTTPS einrichten und in `capacitor.config.ts`
  `androidScheme`/`cleartext` entfernen.
