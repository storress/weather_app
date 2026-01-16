# 🌤️ Weather App (Flutter)

A clean and modular **Flutter weather application** that displays **hourly** and **5-day forecasts** using the **OpenWeather API (v2.5 – free tier)**.

## Run the app

### Install

Install the provided apk: app-profile.apk

### From terminal

```bash
flutter run --dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY
```

### VS Code (launch.json)

```json
"toolArgs": [
  "--dart-define=OPENWEATHER_API_KEY=YOUR_API_KEY"
]
```

## 🗂️ Project Structure

```text
lib/
├── core/
│   ├── config/
│   │   └── env.dart                # Environment variables (API keys)
│   ├── constants/
│   │   ├── endpoints.dart          # API endpoints & image URLs
│   │   └── assets.dart             # Local asset paths
│   └── utils/
│       └── date_formatters.dart    # Date / time formatting helpers
│
├── ui/
│   └── features/
│       ├── home/
│       │   ├── controller/         # UI state orchestration
│       │   ├── dto/                # API DTOs (forecast response)
│       │   ├── models/             # UI models (typed)
│       │   ├── mappers/            # DTO → UI model mappers
│       │   ├── views/              # Pages / screens
│       │   ├── widgets/            # Reusable UI widgets
│       │   └── services/           # Feature-specific services (to be extracted to data/)
│       │
│       └── search/
│           ├── models/             # Search city models
│           ├── delegates/          # SearchDelegate implementations
│           └── widgets/            # Search UI widgets
│
└── main.dart

