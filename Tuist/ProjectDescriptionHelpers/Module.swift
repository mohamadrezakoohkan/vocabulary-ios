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
}

// MARK: - App Module

public enum AppModule: String, Module {
    case app = "App"
}

// MARK: - Feature Modules

public enum FeatureModule: String, Module {
    case splash = "Splash"
    case cards = "Cards"
}

// MARK: - Shared Modules
public enum SharedModule: String, Module {
    case sharedCommon = "SharedCommon"
    case sharedTesting = "SharedTesting"
    case sharedExample = "SharedExample"
}

// MARK: - Core Modules

public enum CoreModule: String, Module {
    case coreFoundation = "ICoreFoundation"
    case coreUI = "ICoreUI"
    case coreModels = "ICoreModels"
    case coreNetwork = "ICoreNetwork"
    case coreDatabase = "ICoreDatabase"
    case coreAnalytics = "ICoreAnalytics"
}
