//
//  DemoEnums.swift
//  ICoreUIExample
//
//  Display helpers for ICoreUI enums (so we can pick values inside the
//  Interactive demos without modifying the source module).
//
//  We deliberately avoid adding `CaseIterable` conformance to types
//  that live in `ICoreUI` to keep this target free of retroactive
//  conformance warnings. Instead, every helper exposes a static
//  `allCases` array and a `Pickable` wrapper.
//

import SwiftUI
import ICoreUI

// MARK: - Pickable Wrapper

/// Generic identifiable wrapper used by every demo `Picker`.
struct Pickable<Value>: Identifiable, Hashable {
    let id: String
    let label: String
    let code: String
    let value: Value

    static func == (lhs: Pickable<Value>, rhs: Pickable<Value>) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - BadgeStyle

extension BadgeStyle {
    static let pickables: [Pickable<BadgeStyle>] = [
        .init(id: "normal",  label: "normal",  code: ".normal",  value: .normal),
        .init(id: "accent",  label: "accent",  code: ".accent",  value: .accent),
        .init(id: "info",    label: "info",    code: ".info",    value: .info),
        .init(id: "success", label: "success", code: ".success", value: .success),
        .init(id: "danger",  label: "danger",  code: ".danger",  value: .danger),
        .init(id: "warning", label: "warning", code: ".warning", value: .warning),
    ]
}

// MARK: - ChipStyle

extension ChipStyle {
    static let pickables: [Pickable<ChipStyle>] = [
        .init(id: "normal",  label: "normal",  code: ".normal",  value: .normal),
        .init(id: "accent",  label: "accent",  code: ".accent",  value: .accent),
        .init(id: "info",    label: "info",    code: ".info",    value: .info),
        .init(id: "success", label: "success", code: ".success", value: .success),
        .init(id: "danger",  label: "danger",  code: ".danger",  value: .danger),
        .init(id: "warning", label: "warning", code: ".warning", value: .warning),
    ]
}

// MARK: - ButtonVariant

extension ButtonVariant {
    static let pickables: [Pickable<ButtonVariant>] = [
        .init(id: "primary",   label: "primary",   code: ".primary",   value: .primary),
        .init(id: "secondary", label: "secondary", code: ".secondary", value: .secondary),
        .init(id: "tertiary",  label: "tertiary",  code: ".tertiary",  value: .tertiary),
        .init(id: "ghost",     label: "ghost",     code: ".ghost",     value: .ghost),
        .init(id: "accent",    label: "accent",    code: ".accent",    value: .accent),
        .init(id: "info",      label: "info",      code: ".info",      value: .info),
        .init(id: "warning",   label: "warning",   code: ".warning",   value: .warning),
        .init(id: "danger",    label: "danger",    code: ".danger",    value: .danger),
    ]
}

// MARK: - CornerStyle

extension CornerStyle {
    static let pickables: [Pickable<CornerStyle>] = [
        .init(id: "small",   label: "small",   code: ".small",   value: .small),
        .init(id: "medium",  label: "medium",  code: ".medium",  value: .medium),
        .init(id: "large",   label: "large",   code: ".large",   value: .large),
        .init(id: "capsule", label: "capsule", code: ".capsule", value: .capsule),
    ]
}

// MARK: - ShadowSize

enum ShadowChoice: String, CaseIterable, Identifiable {
    case none, small, medium, large

    var id: String { rawValue }
    var label: String { rawValue }
    var size: ShadowSize? {
        switch self {
        case .none:   nil
        case .small:  .small
        case .medium: .medium
        case .large:  .large
        }
    }
    var code: String? {
        guard self != .none else { return nil }
        return ".\(rawValue)"
    }
}

// MARK: - Spacing

enum SpacingChoice: String, CaseIterable, Identifiable {
    case xs, sm, smMd, md, mdPlus, mdBig, bg, xb

    var id: String { rawValue }

    var label: String {
        switch self {
        case .xs:     "extraSmall"
        case .sm:     "small"
        case .smMd:   "smallMedium"
        case .md:     "medium"
        case .mdPlus: "mediumPlus"
        case .mdBig:  "mediumBig"
        case .bg:     "big"
        case .xb:     "extraBig"
        }
    }

    var code: String { label }

    var value: CGFloat {
        switch self {
        case .xs:     extraSmall
        case .sm:     small
        case .smMd:   smallMedium
        case .md:     medium
        case .mdPlus: mediumPlus
        case .mdBig:  mediumBig
        case .bg:     big
        case .xb:     extraBig
        }
    }
}

// MARK: - Optional Icon

/// Wrapper for an optional `Icons` value so it can be used in `Picker`
/// without nil edge cases.
struct OptionalIcon: Hashable, Identifiable {
    let value: Icons?
    var id: String { value?.rawValue ?? "__none__" }
    var label: String { value?.rawValue ?? "None" }
    var code: String? { value.map { ".\($0.iconCaseName)" } }

    static let none = OptionalIcon(value: nil)
    static let all: [OptionalIcon] = [.none] + Icons.allCases.map { OptionalIcon(value: $0) }
}

extension Icons {
    /// Reverses the SF Symbol raw value to a Swift case name, since the
    /// raw values are SF Symbol strings (e.g. `chevron.up`).
    var iconCaseName: String {
        switch self {
        case .chevronUp:           "chevronUp"
        case .chevronDown:         "chevronDown"
        case .chevronRight:        "chevronRight"
        case .chevronUpAndDown:    "chevronUpAndDown"
        case .branch:              "branch"
        case .leaf:                "leaf"
        case .leafFill:            "leafFill"
        case .flame:               "flame"
        case .zzz:                 "zzz"
        case .tornado:             "tornado"
        case .sparkle:             "sparkle"
        case .arrowClockwise:      "arrowClockwise"
        case .arrowBranch:         "arrowBranch"
        case .buttonProgrammable:  "buttonProgrammable"
        case .arrowRight:          "arrowRight"
        case .checkmark:           "checkmark"
        case .checkmarkCircleFill: "checkmarkCircleFill"
        case .xmarkCircleFill:     "xmarkCircleFill"
        case .clockFill:           "clockFill"
        case .warning:             "warning"
        case .infoCircleFill:      "infoCircleFill"
        case .heart:               "heart"
        case .star:                "star"
        case .bell:                "bell"
        case .bookmark:            "bookmark"
        case .camera:              "camera"
        case .cloud:               "cloud"
        case .folder:              "folder"
        case .gear:                "gear"
        case .house:               "house"
        case .lock:                "lock"
        case .magnifyingGlass:     "magnifyingGlass"
        case .mapPin:              "mapPin"
        case .message:             "message"
        case .moon:                "moon"
        case .paperplane:          "paperplane"
        case .person:              "person"
        case .phone:               "phone"
        case .photo:               "photo"
        case .trash:               "trash"
        case .wifi:                "wifi"
        case .speaker:             "speaker"
        }
    }
}

// MARK: - Named Colors

enum NamedColor: String, CaseIterable, Identifiable {
    case primaryBlue, primaryRed, primaryYellow, primaryGreen, foreground, foregroundMuted, surface, background

    var id: String { rawValue }
    var label: String { rawValue }
    var code: String { ".\(rawValue)" }

    var color: Color {
        switch self {
        case .primaryBlue:     .primaryBlue
        case .primaryRed:      .primaryRed
        case .primaryYellow:   .primaryYellow
        case .primaryGreen:    .primaryGreen
        case .foreground:      .foreground
        case .foregroundMuted: .foregroundMuted
        case .surface:         .surface
        case .background:      .background
        }
    }
}

// MARK: - Optional Named Color

struct OptionalNamedColor: Hashable, Identifiable {
    let value: NamedColor?
    var id: String { value?.rawValue ?? "__none__" }
    var label: String { value?.label ?? "None" }
    var code: String? { value?.code }
    var color: Color? { value?.color }

    static let none = OptionalNamedColor(value: nil)
    static let all: [OptionalNamedColor] = [.none] + NamedColor.allCases.map { OptionalNamedColor(value: $0) }
}
