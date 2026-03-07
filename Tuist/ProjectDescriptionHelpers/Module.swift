//
//  Module.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription

// MARK: - Module

/// Defines all submodules in the project as enum cases
public enum Module: String, CaseIterable {

    // MARK: - App Module
    case app = "App"

    // MARK: - Feature Modules
    case capture = "Capture"
    case revisit = "Revisit"
    case lineage = "Lineage"
    case evolve = "Evolve"

    // MARK: - Core Modules
    case drovaCoreFoundation = "DrovaCoreFoundation"
    case drovaCoreUI = "DrovaCoreUI"
    case drovaCoreModels = "DrovaCoreModels"
    case drovaCoreNetwork = "DrovaCoreNetwork"
    case drovaCoreDatabase = "DrovaCoreDatabase"
    case drovaCoreAnalytics = "DrovaCoreAnalytics"

    // MARK: - Shared Modules
    case sharedCommon = "SharedCommon"
    case sharedTesting = "SharedTesting"
}


