# Vocabulary iOS

A SwiftUI iOS app for learning vocabulary, organized as a modular Tuist project. The app ships with a pre-seeded SQLite database of words and is split into independently buildable feature modules (Deck, Study, Stats, Splash) backed by reusable Core and Shared libraries.

---

## Table of Contents

1. [Requirements](#requirements)
2. [Bootstrap](#bootstrap)
3. [Common Tasks](#common-tasks)
4. [Project Layout](#project-layout)
5. [Architecture](#architecture)
6. [Module Generation (Tuist)](#module-generation-tuist)
7. [Dependencies](#dependencies)
8. [Database Seeding](#database-seeding)
9. [Adding a New Module](#adding-a-new-module)
10. [Testing](#testing)
11. [Troubleshooting](#troubleshooting)

---

## Requirements

| Tool   | Version            | Purpose                                          |
| ------ | ------------------ | ------------------------------------------------ |
| macOS  | 14+                | Host OS                                          |
| Xcode  | Latest stable      | iOS toolchain (`compatibleXcodeVersions: .all`)  |
| Tuist  | `4.155.3`          | Project generation (pinned in [mise.toml](mise.toml)) |
| Swift  | 6.0                | Language toolchain (driven by Xcode)             |
| Python | 3.x                | Optional — only to re-seed the SQLite DB         |
| mise   | Latest             | Manages the pinned Tuist version                 |

Install [`mise`](https://mise.jdx.dev/) (recommended) to honor the pinned Tuist version automatically:

```bash
brew install mise
mise install        # installs tuist 4.155.3 from mise.toml
```

Alternatively, install Tuist directly:

```bash
curl -Ls https://install.tuist.io | bash
# or
brew tap tuist/tuist && brew install --formula tuist@4.155.3
```

---

## Bootstrap

Clone, install dependencies, and generate the Xcode project:

```bash
git clone <repo-url> vocabulary-ios
cd vocabulary-ios

# 1. Make sure mise is available so the pinned Tuist version is used
mise install

# 2. Resolve Swift Package dependencies declared in Tuist/Package.swift
tuist install

# 3. Generate the Xcode project + workspace
tuist generate
```

`tuist generate` produces [Vocabulary.xcworkspace](Vocabulary.xcworkspace) — open this, **not** the `.xcodeproj`:

```bash
open Vocabulary.xcworkspace
```

Pick the **App** scheme and run on an iOS simulator.

---

## Common Tasks

| Task                                | Command                              |
| ----------------------------------- | ------------------------------------ |
| Generate workspace                  | `tuist generate`                     |
| Resolve / refresh SPM dependencies  | `tuist install`                      |
| Clear Tuist + DerivedData caches    | `tuist clean`                        |
| Build the app from CLI              | `tuist build App`                    |
| Run all unit tests                  | `tuist test`                         |
| Run a single module's tests         | `tuist test ICoreDatabaseTests`      |
| Edit project manifests in Xcode     | `tuist edit`                         |
| Regenerate after manifest changes   | `tuist generate` (folder references discover new files automatically — only needed when manifests/dependencies change) |

> **Tip:** Targets use Xcode `buildableFolders` (folder references with dynamic file discovery). Adding or removing source files **does not** require `tuist generate`. Only manifest, dependency, or module-graph changes do.

---

## Project Layout

```
vocabulary-ios/
├── App/                          # Main iOS app target
│   ├── Sources/                  # App.swift, ContentView.swift, root TabView
│   ├── Resources/                # App-level assets
│   └── Tests/
├── Features/                     # User-facing feature frameworks
│   ├── Splash/
│   ├── Deck/                     # Word/deck browsing
│   ├── Study/                    # Flashcard/study flow
│   └── Stats/                    # Learning statistics
├── Core/                         # Cross-cutting infrastructure frameworks
│   ├── ICoreFoundation/          # Base utilities, no dependencies
│   ├── ICoreModels/              # Domain models (Word, Category, …)
│   ├── ICoreUI/                  # Design system: Colors, Icons, Components, Styles
│   ├── ICoreDatabase/            # SQLite + SQLiteData persistence
│   ├── ICoreNetwork/             # Networking layer
│   └── ICoreAnalytics/           # Analytics abstractions
├── Shared/                       # Cross-module helpers
│   ├── SharedCommon/             # ServiceProvider, app-wide glue
│   ├── SharedTesting/            # Test helpers and fixtures
│   └── SharedExample/            # Demo-app helpers used by *Example apps
├── Tuist/
│   ├── Package.swift             # External SPM dependencies (sqlite-data)
│   ├── Package.resolved
│   └── ProjectDescriptionHelpers/
│       ├── Module.swift          # Enum-based module catalog
│       ├── ModuleProperties.swift# bundleId, paths, dependency graph
│       └── TargetProvider.swift  # Generates product/test/example targets
├── Scripts/
│   ├── seed_data/                # CSV + JSON source data
│   └── seed_vocabulary_db.py     # Builds the bundled vocabulary.sqlite
├── Project.swift                 # Top-level Tuist project manifest
├── Tuist.swift                   # Tuist toolchain configuration
└── mise.toml                     # Pins tuist = 4.155.3
```

---

## Architecture

The codebase follows a **strict, layered modular architecture** where each layer can only depend on the layers below it. The dependency direction is enforced by [ModuleProperties.swift](Tuist/ProjectDescriptionHelpers/ModuleProperties.swift).

```
┌────────────────────────────────────────────────────────┐
│                          App                           │  ← composition root
│      (depends on every Feature + Core + SharedCommon)  │
└────────────────────────────────────────────────────────┘
                            │
       ┌───────────────┬────┴────┬────────────────┐
       ▼               ▼         ▼                ▼
   ┌────────┐    ┌────────┐  ┌────────┐    ┌────────┐
   │ Splash │    │  Deck  │  │ Study  │    │ Stats  │      Feature layer
   └────────┘    └────────┘  └────────┘    └────────┘
       │ each Feature depends on every Core module
       ▼
┌────────────────────────────────────────────────────────┐
│                       Core layer                        │
│                                                         │
│  ICoreNetwork ──┐                                       │
│      │          ├──► ICoreDatabase ──► ICoreModels      │
│      │          │                          │            │
│  ICoreAnalytics─┘                          ▼            │
│                                      ICoreFoundation    │
│                                                         │
│  ICoreUI (independent — no Core deps)                   │
└────────────────────────────────────────────────────────┘
                            │
                            ▼
              ┌──────────────────────────┐
              │        Shared layer       │
              │  SharedCommon / Testing  │
              │   (build on Core)         │
              └──────────────────────────┘
```

### Layer rules

| Layer        | Allowed dependencies                                                       |
| ------------ | -------------------------------------------------------------------------- |
| **App**      | All Features, all Core modules, `SharedCommon`                             |
| **Features** | All Core modules (no other Features, no Shared)                            |
| **Core**     | Only lower Core modules — see graph below                                  |
| **Shared**   | Core modules; `SharedExample` additionally depends on `SharedCommon`       |

### Core dependency graph

```
ICoreFoundation         (leaf — no deps)
ICoreUI                 (leaf — no deps; design system)
ICoreModels             → ICoreFoundation
ICoreAnalytics          → ICoreFoundation, ICoreModels
ICoreDatabase           → ICoreFoundation, ICoreModels, [SQLiteData]
ICoreNetwork            → ICoreFoundation, ICoreModels, ICoreDatabase
```

### Composition

The app is composed in [App/Sources/App.swift](App/Sources/App.swift):

- A `ServiceProvider` (from `SharedCommon`) is injected into the SwiftUI environment.
- The root `MainView` is a `TabView` wiring `DeckView`, `StudyView`, and `StatsView` from their respective feature modules.
- Tab styling pulls colors and icons from `ICoreUI`'s design system (`Color.primaryYellow`, `Color.primaryRed`, `Icon(.deckTab)`, …).

---

## Module Generation (Tuist)

Modules are declared as **enum cases** rather than free-form manifest blocks. Adding or modifying a module touches three files:

- [Module.swift](Tuist/ProjectDescriptionHelpers/Module.swift) — declares the module enum case and which targets it produces (`product`, `tests`, `example`).
- [ModuleProperties.swift](Tuist/ProjectDescriptionHelpers/ModuleProperties.swift) — bundle IDs, source paths, and the dependency graph.
- [TargetProvider.swift](Tuist/ProjectDescriptionHelpers/TargetProvider.swift) — turns a `Module` into a list of `ProjectDescription.Target`s.

For each module, up to three targets are generated:

| Target                | Type        | When generated                | Dependencies                                  |
| --------------------- | ----------- | ----------------------------- | --------------------------------------------- |
| `<Module>`            | framework / app | `includeProductTarget`     | per dependency graph                          |
| `<Module>Tests`       | unit tests  | `includeTestTarget`           | `<Module>` + `SharedTesting`                  |
| `<Module>Example`     | demo app    | `includeExampleTarget`        | `<Module>` (+ `SharedExample`, except `ICoreUI`) |

`Project.swift` simply flattens all module targets into a single project:

```swift
let modules: [any Module] =
    AppModule.allCases + FeatureModule.allCases + SharedModule.allCases + CoreModule.allCases
let targets = modules.flatMap(\.targets)
```

### Module catalog

| Layer    | Module             | Product | Example | Tests |
| -------- | ------------------ | ------- | ------- | ----- |
| App      | App                | app     | —       | ✅    |
| Feature  | Splash             | fwk     | ✅      | ✅    |
| Feature  | Deck               | fwk     | ✅      | ✅    |
| Feature  | Study              | fwk     | ✅      | ✅    |
| Feature  | Stats              | fwk     | ✅      | ✅    |
| Core     | ICoreFoundation    | fwk     | —       | ✅    |
| Core     | ICoreUI            | fwk     | ✅      | ✅    |
| Core     | ICoreModels        | fwk     | —       | ✅    |
| Core     | ICoreNetwork       | fwk     | —       | ✅    |
| Core     | ICoreDatabase      | fwk     | —       | ✅    |
| Core     | ICoreAnalytics     | fwk     | —       | ✅    |
| Shared   | SharedCommon       | fwk     | —       | ✅    |
| Shared   | SharedTesting      | fwk     | —       | ✅    |
| Shared   | SharedExample      | fwk     | —       | ✅    |

Bundle IDs follow the pattern `vocabulary.com.<ModuleName>` (and `vocabulary.com.<ModuleName>Example` / `…Tests`).

---

## Dependencies

External packages are declared in [Tuist/Package.swift](Tuist/Package.swift) and resolved via `tuist install`:

| Package                                                                    | Used by         |
| -------------------------------------------------------------------------- | --------------- |
| [`pointfreeco/sqlite-data`](https://github.com/pointfreeco/sqlite-data)    | `ICoreDatabase` |

To add a new SPM dependency:

1. Add `.package(url: …, from: "x.y.z")` to `Tuist/Package.swift`.
2. Reference it from the appropriate module via `.external(name: "PackageProduct")` in `ModuleProperties.swift` → `dependencies`.
3. Run `tuist install && tuist generate`.

---

## Database Seeding

The app bundles a pre-built SQLite file at `Core/ICoreDatabase/Resources/vocabulary.sqlite`. It is generated from CSV and JSON sources under [Scripts/seed_data/](Scripts/seed_data/).

Re-seed whenever the source data changes:

```bash
python3 Scripts/seed_vocabulary_db.py
```

Schema (defined in [Scripts/seed_vocabulary_db.py](Scripts/seed_vocabulary_db.py)):

- `words(id, term, phonetic, translation, example, exampleTranslation)`
- `categories(id, name)`
- `wordCategories(wordID, categoryID)` — many-to-many

The output `.sqlite` is committed to the repo so the app ships pre-populated.

---

## Adding a New Module

Example: adding a `Profile` feature.

1. **Declare the module** in [Module.swift](Tuist/ProjectDescriptionHelpers/Module.swift):

   ```swift
   public enum FeatureModule: String, Module {
       case splash = "Splash"
       case deck = "Deck"
       case study = "Study"
       case stats = "Stats"
       case profile = "Profile"   // ← new
       …
   }
   ```

2. **Create the directory layout**:

   ```
   Features/Profile/
   ├── Sources/
   ├── Resources/
   ├── Tests/
   └── Example/
   ```

3. **(Optional) override dependencies** in [ModuleProperties.swift](Tuist/ProjectDescriptionHelpers/ModuleProperties.swift) if the default Feature graph (all Core modules) is wrong.

4. **Wire it into the app** by importing it in [App/Sources/App.swift](App/Sources/App.swift) — `AppModule` already depends on every `FeatureModule`, so the framework link happens automatically.

5. **Regenerate**:

   ```bash
   tuist generate
   ```

---

## Testing

- Each module has a `<Module>Tests` target that links the module under test plus `SharedTesting`.
- Run all tests:

  ```bash
  tuist test
  ```

- Run a single module's tests:

  ```bash
  tuist test ICoreDatabaseTests
  ```

- Inside Xcode: pick the test target's scheme (or the `App` scheme) and ⌘U.

`SharedTesting` is the canonical place for fixtures, mocks, and helpers consumed across test targets — keep production code out of it.

---

## Troubleshooting

| Symptom                                                  | Fix                                                                                          |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `tuist: command not found`                               | Run `mise install` (or install Tuist directly). Ensure `mise activate` is in your shell rc. |
| Wrong Tuist version warnings                             | The repo is pinned to `4.155.3` in [mise.toml](mise.toml); use `mise install`.              |
| Missing SPM packages, "no such module 'SQLiteData'"      | Run `tuist install` then `tuist generate`.                                                   |
| Stale generated project                                  | `tuist clean && tuist install && tuist generate`.                                            |
| Newly added source file not picked up                    | Targets use folder references — a clean Xcode build should suffice. If not, `tuist generate`.|
| Bundled DB out of date                                   | Re-run `python3 Scripts/seed_vocabulary_db.py`.                                              |

---

## Conventions

- **Open `.xcworkspace`, not `.xcodeproj`** — the workspace is the regenerable unit.
- **Do not commit** files inside `Derived/`. They are produced by Tuist.
- **Cross-module imports** must respect the layer rules above; if you find yourself wanting a Feature → Feature import, lift the shared code into a Core or Shared module instead.
- **Design tokens** (colors, icons, components) live in `ICoreUI` — features should not redefine them.
