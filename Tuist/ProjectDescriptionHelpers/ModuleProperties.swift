//
//  ModuleProperties.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription

// MARK: - Module Properties

public extension Module {
    /// The display name for the module
    var name: String {
        rawValue
    }

    /// The bundle identifier for this module
    var bundleId: String {
        "com.drova.\(rawValue)"
    }

    /// The product type for this module
    var product: Product {
        switch self {
        case .app:
            return .app
        case .capture, .revisit, .lineage, .evolve:
            return .framework
        case .drovaCoreFoundation,
                .drovaCoreUI,
                .drovaCoreModels,
                .drovaCoreNetwork,
                .drovaCoreDatabase,
                .drovaCoreAnalytics:
            return .framework
        case .sharedCommon, .sharedTesting:
            return .framework
        }
    }

    /// The path to the module's sources
    var sourcesPath: String {
        switch self {
        case .app:
            "App/Sources"
        case .capture, .revisit, .lineage, .evolve:
            "Features/\(name)/Sources"
        case .drovaCoreFoundation,
                .drovaCoreUI,
                .drovaCoreModels,
                .drovaCoreNetwork,
                .drovaCoreDatabase,
                .drovaCoreAnalytics:
            "Core/\(name)/Sources"
        case .sharedCommon, .sharedTesting:
            "Shared/\(name)/Sources"
        }
    }

    /// The path to the module's resources
    var resourcesPath: String {
        switch self {
        case .app:
            "App/Resources"
        case .capture, .revisit, .lineage, .evolve:
            "Features/\(name)/Resources"
        case .drovaCoreFoundation,
                .drovaCoreUI,
                .drovaCoreModels,
                .drovaCoreNetwork,
                .drovaCoreDatabase,
                .drovaCoreAnalytics:
            "Core/\(name)/Resources"
        case .sharedCommon, .sharedTesting:
            "Shared/\(name)/Resources"
        }
    }

    /// The path to the module's tests
    var testsPath: String {
        switch self {
        case .app:
            "App/Tests"
        case .capture, .revisit, .lineage, .evolve:
            "Features/\(name)/Tests"
        case .drovaCoreFoundation,
                .drovaCoreUI,
                .drovaCoreModels,
                .drovaCoreNetwork,
                .drovaCoreDatabase,
                .drovaCoreAnalytics:
            "Core/\(name)/Tests"
        case .sharedCommon, .sharedTesting:
            "Shared/\(name)/Tests"
        }
    }

    /// Dependencies for this module
    var dependencies: [TargetDependency] {
        switch self {
        case .capture, .revisit, .lineage, .evolve:
            return [
                .target(name: Module.drovaCoreFoundation.name),
                .target(name: Module.drovaCoreUI.name),
                .target(name: Module.drovaCoreModels.name),
                .target(name: Module.drovaCoreNetwork.name),
                .target(name: Module.drovaCoreDatabase.name),
                .target(name: Module.drovaCoreAnalytics.name),
            ]
        case .drovaCoreUI, .drovaCoreFoundation:
            return []
        case .drovaCoreModels:
            return [.target(name: Module.drovaCoreFoundation.name)]
        case .drovaCoreNetwork, .drovaCoreDatabase, .drovaCoreAnalytics:
            return [
                .target(name: Module.drovaCoreFoundation.name),
                .target(name: Module.drovaCoreModels.name),
            ]
        case .sharedCommon:
            return [
                .target(name: Module.drovaCoreFoundation.name),
                .target(name: Module.drovaCoreUI.name),
                .target(name: Module.drovaCoreModels.name),
                .target(name: Module.drovaCoreNetwork.name),
                .target(name: Module.drovaCoreDatabase.name),
                .target(name: Module.drovaCoreAnalytics.name),
            ]
        case .sharedTesting:
            return [
                .target(name: Module.drovaCoreFoundation.name),
                .target(name: Module.drovaCoreModels.name),
            ]
        case .app:
            return [
                .target(name: Module.capture.name),
                .target(name: Module.revisit.name),
                .target(name: Module.lineage.name),
                .target(name: Module.evolve.name),
                .target(name: Module.sharedCommon.name),
                .target(name: Module.drovaCoreFoundation.name),
                .target(name: Module.drovaCoreUI.name),
                .target(name: Module.drovaCoreModels.name),
                .target(name: Module.drovaCoreNetwork.name),
                .target(name: Module.drovaCoreDatabase.name),
                .target(name: Module.drovaCoreAnalytics.name),
            ]
        }
    }
}
