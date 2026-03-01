# nutrition_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

Quick start — single-server (serves API and static pages)

1) Install Python and create venv

```powershell
# Windows PowerShell (from project root)
python -m venv .venv
.\\.venv\\Scripts\\Activate.ps1
pip install --upgrade pip
pip install fastapi uvicorn
```

2) Run single server (serves static files and `/dishes` API)

```powershell
# Start backend + static files together (default port 8000)
python -m uvicorn nutrition_backend.main:app --host 127.0.0.1 --port 8000
```

3) Open site

- Dishes page: http://127.0.0.1:8000/ready-to-cook-dishes.html
- API test: http://127.0.0.1:8000/dishes

Run with custom port (e.g. 8080) and a watchdog (auto-restart) from the helper script:

```powershell
# run foreground on port 8080
.\scripts\run.ps1 -Port 8080

# run with auto-restart (watchdog)
.\scripts\run.ps1 -Port 8080 -Watchdog

# run in background (opens browser)
.\scripts\run.ps1 -Port 8080 -Bg
```

Troubleshooting
- If `python` is not found, install Python from https://python.org and enable "Add Python to PATH".
- If you prefer two processes, run `uvicorn` for API and `python -m http.server` for static files as documented earlier.

Notes
- The FastAPI app mounts the project root as static files so a single `uvicorn` command serves both the frontend and the API.
- If you want a production deploy, consider using a proper ASGI server behind a reverse proxy and configure CORS/security settings.
