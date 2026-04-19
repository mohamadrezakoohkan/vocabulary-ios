---
name: icoreui-demos
description: Keeps the ICoreUIExample app in sync with the ICoreUI module. Use when adding, removing, renaming, or modifying any file under Core/ICoreUI/Sources/Components/Views, Core/ICoreUI/Sources/Components/Styles, Core/ICoreUI/Sources/Colors, or Core/ICoreUI/Sources/Icons — the agent updates the matching demo under Core/ICoreUI/Example/Components or scaffolds a new one with the standard 2-tab Interactive + Combinations structure, and registers it in Core/ICoreUI/Example/RootView.swift.
---

# ICoreUI Demos

Every public component, style, color, and icon in `Core/ICoreUI/Sources/` has a matching demo screen in `Core/ICoreUI/Example/Components/`. Whenever the source changes, the demo MUST change with it. Whenever a new public surface is added, a demo MUST be scaffolded alongside it.

## When to Use This Skill

Trigger any time you:

1. Edit a public init, parameter, case, or visual behavior in `Core/ICoreUI/Sources/Components/Views/*.swift` or `Core/ICoreUI/Sources/Components/Styles/*.swift`.
2. Add, remove, or rename a `Color` extension in `Core/ICoreUI/Sources/Colors/Colors.swift`.
3. Add, remove, or rename a case in the `Icons` enum in `Core/ICoreUI/Sources/Icons/Icons.swift`.
4. Create a brand-new file under `Core/ICoreUI/Sources/Components/{Views,Styles}/` or a new public type in `Colors.swift`/`Icons.swift`.

Do NOT trigger for:

- Internal refactors that don't change public API or visuals.
- Comment-only changes.
- Files outside `Core/ICoreUI/Sources/`.

## File Map

| Source                                               | Demo                                                                       |
| ---------------------------------------------------- | -------------------------------------------------------------------------- |
| `Sources/Components/Views/<Name>.swift`              | `Example/Components/Views/<Name>Demo.swift`                                |
| `Sources/Components/Styles/<Name>.swift`             | `Example/Components/Styles/<Name>Demo.swift`                               |
| `Sources/Colors/Colors.swift`                        | `Example/Components/Foundations/ColorsDemo.swift`                          |
| `Sources/Icons/Icons.swift`                          | `Example/Components/Foundations/IconsDemo.swift`                           |

Every source file's header comment block has an `AI Instructions:` section ending with a `Demo:` line that points at the exact demo path. Trust those links.

## Demo Architecture (cheat sheet)

Shared scaffold — do NOT re-implement these:

- `DemoScreen(title:, interactive:, combinations:)` — the 2-tab container. Always wrap demos in this.
- `InteractiveScroll { ... }` — `ScrollView` for the Interactive tab. Use it.
- `CombinationsScroll { ... }` — `ScrollView` for the Combinations tab. Use it.
- `PreviewSurface(title:, alignment:) { ... }` — soft padded canvas for the live preview.
- `ControlsSection(title:) { ... }` — surface card grouping form controls.
- `LabeledRow(label:) { ... }` — label + content row.
- `TextFieldRow`, `StepperRow`, `SliderRow` — pre-built control rows.
- `CodeBlock(code:)` — monospaced Swift snippet with Copy button.
- `swiftCall(name, positional:, arguments:)` — generates an init call. `nil` arguments are dropped.
- `swiftStringLiteral(_:)` — escapes a `String` for a code snippet.
- `CombinationGroup(title:) { ... }` — section in the Combinations tab.
- `DemoFlowLayout(spacing:) { ... }` — wrapping layout for chip/badge grids.

Pickable enum support — when adding/removing/renaming an enum case in `BadgeStyle`, `ChipStyle`, `ButtonVariant`, or `CornerStyle`, update its `.pickables` array in `Core/ICoreUI/Example/Shared/DemoEnums.swift`. When adding/removing/renaming an `Icons` case, update `iconCaseName` in the same file.

## Workflow A — Modifying an existing component

When changing a source file under `Core/ICoreUI/Sources/`:

1. Read the source file's header. Follow its `Demo:` link to the matching demo.
2. Read the demo file. It has two private types: `Interactive` and `Combinations`.
3. Reflect the change in BOTH tabs:
   - **Interactive**: add/remove/rename the matching `@State` + `LabeledRow`/`Picker`/`Toggle` and update the `codeSnippet` so the generated call matches the new API exactly.
   - **Combinations**: add/remove/rename the corresponding `CombinationGroup` rows so every variant is still represented at least once.
4. If the change touches `BadgeStyle`/`ChipStyle`/`ButtonVariant`/`CornerStyle`/`Icons`/`Color` extensions: update the matching catalog in `Core/ICoreUI/Example/Shared/DemoEnums.swift` (`.pickables`, `iconCaseName`, `NamedColor`) and in `Example/Components/Foundations/{Colors,Icons}Demo.swift` if applicable.
5. Build to verify:
   ```bash
   xcodebuild -workspace Vocabulary.xcworkspace -scheme ICoreUI \
     -destination 'generic/platform=iOS Simulator' -configuration Debug build
   ```

## Workflow B — Adding a new component

When creating a new file under `Core/ICoreUI/Sources/Components/{Views,Styles}/`:

1. Add an `AI Instructions:` block at the top of the source file ending with a `Demo:` line that points at the demo path you'll create. Match the style of existing components.
2. Create the demo file at the path from Workflow A's File Map. Use the appropriate template below.
3. Register the demo in `Core/ICoreUI/Example/RootView.swift` inside the right `Section` (alphabetical), e.g. `NavigationLink("FooView") { FooViewDemo() }`.
4. If the new file introduces a new enum that should be pickable from other demos (e.g. a new `BadgeStyle`-like enum), add a `Pickable<T>` static array in `Example/Shared/DemoEnums.swift`.
5. Regenerate the project and build:
   ```bash
   mise exec -- tuist generate --no-open
   xcodebuild -workspace Vocabulary.xcworkspace -scheme ICoreUI \
     -destination 'generic/platform=iOS Simulator' -configuration Debug build
   ```

## Templates

### Template 1 — View Demo

```swift
//
//  <Name>Demo.swift
//  ICoreUIExample
//

import SwiftUI
import ICoreUI

struct <Name>Demo: View {
    var body: some View {
        DemoScreen(
            title: "<Name>",
            interactive: { Interactive() },
            combinations: { Combinations() }
        )
    }
}

// MARK: - Interactive

private struct Interactive: View {
    // One @State per public init parameter.
    @State private var someText: String = "Sample"

    var body: some View {
        InteractiveScroll {
            PreviewSurface(alignment: .leading) {
                <Name>(/* pass @State values */)
            }
            CodeBlock(code: codeSnippet)

            ControlsSection(title: "Customize") {
                TextFieldRow(label: "Some text", text: $someText)
                // LabeledRow + Picker / Toggle / Stepper / Slider for every other input.
            }
        }
    }

    private var codeSnippet: String {
        swiftCall(
            "<Name>",
            positional: [],
            arguments: [
                ("someText", swiftStringLiteral(someText)),
                // (label, value-or-nil) per parameter. Pass nil to omit defaults.
            ]
        )
    }
}

// MARK: - Combinations

private struct Combinations: View {
    var body: some View {
        CombinationsScroll {
            CombinationGroup(title: "Group 1") {
                // Render every meaningful variant axis at least once.
            }
        }
    }
}

#Preview {
    NavigationStack { <Name>Demo() }
}
```

### Template 2 — Style Demo

For pure style enums (no view to render):

1. Pick a representative consumer view (e.g. `BadgeStyle` → `BadgeView`, `CornerStyle` → `Rectangle()`/`AppButtonStyle`).
2. Render that consumer in `PreviewSurface` driven by a `Picker` over the style cases.
3. In Combinations, iterate `<StyleType>.pickables` and show each case applied to the consumer.
4. Add a `.pickables` array for the new style in `Example/Shared/DemoEnums.swift` if it isn't there yet.

Use `BadgeStyleDemo.swift`, `ButtonStyleDemo.swift`, or `CornerStyleDemo.swift` as the closest reference.

## Generating Code Snippets

Always use `swiftCall` + `swiftStringLiteral` so the snippet stays escaped and consistent:

```swift
swiftCall(
    "BadgeView",
    positional: [swiftStringLiteral(label)],   // first init arg
    arguments: [
        ("style",        ".\(styleLabel)"),    // pass nil to omit
        ("leadingIcon",  leadingIcon.code),    // OptionalIcon.code returns nil for .none
        ("trailingIcon", trailingIcon.code),
    ]
)
```

Rules:

- Pass `nil` for `value` to drop a parameter from the snippet entirely (good for optional inputs).
- Use `swiftStringLiteral(...)` for any user-controlled `String`.
- For numeric values use `"\(Int(value))"` to avoid `.0` noise.
- For closure handlers use a placeholder body: `"{ /* tap */ }"` — never embed Swift state captures.

## Picker Selection — Hashability Note

`BadgeStyle`, `ChipStyle`, `ButtonVariant` are plain enums without associated values, so SwiftUI auto-conforms them to `Hashable` — bind `Picker` selection directly to the enum.

`CornerStyle` has `.custom(CGFloat)`, so it does NOT auto-conform to `Hashable`. For its `Picker`, bind to a `Pickable<CornerStyle>` wrapper from `DemoEnums.swift` instead and read `.value` when applying it.

## Verification Checklist

Before you finish, confirm:

- [ ] Source file's `AI Instructions: Demo:` line points at the correct demo path.
- [ ] Demo's Interactive tab exposes a control for every public init parameter.
- [ ] Demo's Interactive `codeSnippet` matches the new public API (run through your head: copy it into a file, would it compile?).
- [ ] Demo's Combinations tab covers every meaningful axis (every enum case, every accessory mode, optional vs. provided handlers, etc.).
- [ ] If an enum changed: `Example/Shared/DemoEnums.swift` `.pickables` / `iconCaseName` / `NamedColor` were updated.
- [ ] If a new file: it's wired into the correct `Section` in `Core/ICoreUI/Example/RootView.swift`.
- [ ] `xcodebuild ... -scheme ICoreUI ... build` succeeds.
- [ ] No new linter errors in the touched files.

## Anti-Patterns

- ❌ Don't add `CaseIterable` / `Hashable` retroactive conformance to ICoreUI types from the demo target. Use the `Pickable<T>` wrapper + `.pickables` array pattern in `DemoEnums.swift` instead.
- ❌ Don't shadow ICoreUI's spacing globals (`extraSmall`, `small`, `medium`, …) with case names in the demo target. The existing `SpacingChoice` uses short aliases (`.xs`, `.sm`, `.md`, …) on purpose.
- ❌ Don't roll your own preview chrome. Always use `DemoScreen` + `PreviewSurface` + `CodeBlock` + `ControlsSection` + `CombinationGroup`.
- ❌ Don't skip the build step. Demos compile against `ICoreUI`, so an API rename will silently break the demo until you build.
