//
//  ModuleProperties.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription

// MARK: - Module Properties

public extension Module {
    /// The bundle identifier for this module
    var bundleId: String {
        "vocabulary.com.\(rawValue)"
    }

    /// The product type for this module
    var product: Product {
        switch self {
        case is AppModule:
            return .app
        case is FeatureModule:
            return .framework
        case is CoreModule:
            return .framework
        case is SharedModule:
            return .framework
        default:
            fatalError("Module type not found")
        }
    }

    var infoPlist: InfoPlist? {
        switch self {
        case is AppModule:
            return .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
            ])
        default:
            return InfoPlist.default
        }
    }

    /// The base path for this module's directory
    var basePath: String {
        switch self {
        case is AppModule:
            "App"
        case is FeatureModule:
            "Features/\(rawValue)"
        case is CoreModule:
            "Core/\(rawValue)"
        case is SharedModule:
            "Shared/\(rawValue)"
        default:
            fatalError("Module type not found")
        }
    }

    var sourcesPath: String { "\(basePath)/Sources" }
    var resourcesPath: String { "\(basePath)/Resources" }
    var testsPath: String { "\(basePath)/Tests" }
    var examplePath: String { "\(basePath)/Example" }

    /// A target dependency referencing this module
    var targetDependency: TargetDependency {
        .target(name: rawValue)
    }

    /// Dependencies for this module
    var dependencies: [TargetDependency] {
        switch self {
        case is AppModule:
            FeatureModule.allCases.map(\.targetDependency) +
            CoreModule.allCases.map(\.targetDependency) +
            [SharedModule.sharedCommon.targetDependency]
        case is FeatureModule:
            CoreModule.allCases.map(\.targetDependency)
        case let core as CoreModule:
            switch core {
            case .coreUI, .coreFoundation:
                []
            case .coreModels:
                [CoreModule.coreFoundation.targetDependency]
            case .coreNetwork, .coreDatabase, .coreAnalytics:
                [CoreModule.coreFoundation, .coreModels].map(\.targetDependency)
            }
        case let shared as SharedModule:
            switch shared {
            case .sharedCommon:
                CoreModule.allCases.map(\.targetDependency)
            case .sharedTesting:
                [CoreModule.coreFoundation, .coreModels].map(\.targetDependency)
            case .sharedExample:
                CoreModule.allCases.map(\.targetDependency) + [SharedModule.sharedCommon.targetDependency]
            }
        default:
            fatalError("Module type not found")
        }
    }
}
