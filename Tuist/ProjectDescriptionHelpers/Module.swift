//
//  Module.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription

// MARK: - Module

/// Defines all submodules in the project as enum cases
public protocol Module: CaseIterable, Sendable {
    /// The display name for the module
    var rawValue: String { get }
    var includeProductTarget: Bool { get }
    var includeExampleTarget: Bool { get }
    var includeTestTarget: Bool { get }
}

// MARK: - App Module

public enum AppModule: String, Module {
    case app = "App"

    public var includeProductTarget: Bool { true }
    public var includeExampleTarget: Bool { false }
    public var includeTestTarget: Bool { true }
}

// MARK: - Feature Modules

public enum FeatureModule: String, Module {
    case splash = "Splash"
    case cards = "Cards"

    public var includeProductTarget: Bool { true }
    public var includeExampleTarget: Bool { true }
    public var includeTestTarget: Bool { true }
}

// MARK: - Shared Modules
public enum SharedModule: String, Module {
    case sharedCommon = "SharedCommon"
    case sharedTesting = "SharedTesting"
    case sharedExample = "SharedExample"

    public var includeProductTarget: Bool { true }
    public var includeExampleTarget: Bool { false }
    public var includeTestTarget: Bool { true }
}

// MARK: - Core Modules

public enum CoreModule: String, Module {
    case coreFoundation = "ICoreFoundation"
    case coreUI = "ICoreUI"
    case coreModels = "ICoreModels"
    case coreNetwork = "ICoreNetwork"
    case coreDatabase = "ICoreDatabase"
    case coreAnalytics = "ICoreAnalytics"

    public var includeProductTarget: Bool { true }
    public var includeTestTarget: Bool { true }
    public var includeExampleTarget: Bool {
        switch self {
        case .coreUI:
            true
        default:
            false
        }
    }
}
