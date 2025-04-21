# SmartTravel

**SmartTravel** is an iOS app (Swift 5 / SwiftUI 3) that lets travellers:

* create accounts & sign in  
* generate AI‑powered itineraries with Google Gemini  
* browse a catalogue of 5 curated “Discover” trips and add them to *My Trips*  
* store trips **per‑user** in Core Data (each account sees only its own)  
* view rich place details (rating, address, map pin) via Google Places + MapKit

---

## Table of Contents
1. [Features](#features)  
2. [Architecture](#architecture)  
3. [Tech Stack](#tech-stack)  
4. [Setup](#setup)  
5. [How it Works](#how-it-works)  
6. [Folder Structure](#folder-structure)  
7. [Roadmap](#roadmap)  
8. [License](#license)

---

## Features

| Category | Details |
|----------|---------|
| **Authentication** | Local Core Data `User` table; login / register / change‑password; text‑fields reset on logout. |
| **Trip Wizard** | Destination → Travellers → Budget → Dates → Review → *AI build* → Loading animation → Itinerary result. |
| **AI Generation** | `GeminiService` calls Google Gemini 2.0 (Pro/Flash) and maps clean JSON into `DayPlan` models. |
| **Discover** | 5 hand‑picked itineraries (1‑4 days) you can preview & add to *My Trips*. |
| **Per‑User Storage** | Each `Trip` is tagged with the creating user’s UUID; `MyTripsView` filters automatically. |
| **Map Details** | Google Places “FindPlaceFromText” → rating, address, pin overlay in `ActivityDetailView`. |
| **Offline‑first** | Core Data persistence with lightweight migration. |
| **Modern UI** | 100 % SwiftUI, dark‑mode‑ready, SF Symbols, gradient titles, custom calendar grid. |

---

## Architecture

SmartTravel follows **MVVM**:

View ──► binds──► ViewModel ──► Model layer (Core Data / Services)

* **ViewModels** – `AuthViewModel`, `TripViewModel`, `DestinationSearchViewModel`, `OnboardingViewModel`  
* **Services** – `GeminiService` (AI), `PlaceDetailViewModel` (Google Places)  
* **Models** – `User`, `Trip`, `DayPlan`, `Event` + enums (`BudgetRange`, `TravelParty`)  
* **Persistence** – `PersistenceController` wraps `NSPersistentContainer`

---

## Tech Stack

| Area        | Library / API                            |
|-------------|------------------------------------------|
| Language    | Swift 5.10                               |
| UI          | SwiftUI 3, SF Symbols, MapKit            |
| Storage     | Core Data                                |
| AI          | Google Generative AI – gemini‑2.0‑pro / flash |
| Places      | Google Places REST API (FindPlaceFromText) |
| Build       | Xcode 15+                                |
| Minimum OS  | iOS 17.0 (tested on iOS 18 simulator)    |

---


## Setup

### 1. Clone the repository

```bash
git clone https://github.com/amitabhsinghh/SmartTravel.git
cd SmartTravel
```

### 2. Open the project

```bash
open SmartTravel.xcodeproj
```

### 3. Configure API keys

Create a file called `Secrets.xcconfig` (already git‑ignored) and add:

```text
GEMINI_KEY = <your-gemini-api-key>
PLACES_KEY = <your-google-places-key>
```

Then in **Build Settings ▸ Swift Compiler – Custom Flags**, add:

```ini
-DGEMINI_KEY="$(GEMINI_KEY)"
-DPLACES_KEY="$(PLACES_KEY)"
```

> ⚠️ You can also hard‑code the keys in `GeminiService.swift` and `GooglePlaceSearchResult.swift` (less secure, not recommended).

### 4. Run

Select an iPhone simulator (e.g. iPhone 15 Pro) and press ▶︎ Run.

---

## How it Works

- User signs in → `AuthViewModel` stores a `User` entity and toggles `isLoggedIn`.
- `Wizard` (inside `HomeView`) collects destination, travellers, budget, dates.
- `ReviewTripView` calls `TripViewModel.generate()` which invokes `GeminiBuilder.build()`.
- `GeminiService` returns raw JSON → decoded into `[DayPlan]` → held in `TripViewModel`.
- `LoadingView` animates until generation finishes, then pushes `ItineraryResultsView`.
- Save writes a `Trip` with `userId == currentUser.id`; `MyTripsView` filters by that ID.
- `DiscoverView` shows static itineraries; tapping Add duplicates them into Core Data.
- `ActivityDetailView` fetches Google Places info and renders a MapKit preview.

---

## Folder Structure

```bash
SmartTravel/
├── CoreData/              # .xcdatamodeld schema
├── Models/                # value types & NSManagedObject subclasses
├── ViewModels/            # business logic
├── Views/                 # SwiftUI screens & components
├── Services/              # network / AI helpers
├── Resources/             # Assets.xcassets, LaunchScreen.storyboard
```

---

## License

MIT License © [Amitabh Singh](https://github.com/amitabhsinghh)
✅ 
