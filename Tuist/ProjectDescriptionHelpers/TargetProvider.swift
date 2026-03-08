//
//  ProjectProvider.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription


// MARK: - Module Target Generation

public extension Module {
    /**
     Generates a Target for this module.
     
     Uses `buildableFolders` for file inclusion (folder references with dynamic discovery).
     
     Alternative approach using glob patterns (requires regeneration on file changes):
     ```
     sources: ["\(sourcesPath)/\**"],
     resources: ["\(resourcesPath)/\**"],
     sources: ["\(testsPath)/\**"],
     ```
     Note: `sources`/`resources` and `buildableFolders` are mutually exclusive.
     */
    func makeTarget() -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: bundleId,
            infoPlist: infoPlist,
            buildableFolders: [
                .folder(.path(sourcesPath)),
                .folder(.path(resourcesPath))
            ],
            dependencies: dependencies
        )
    }
    
    /// Generates a test Target for this module
    func makeTestTarget() -> Target {
        .target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId)Tests",
            buildableFolders: [.folder(.path(testsPath))],
            dependencies: [.target(name: name), .target(name: Module.sharedTesting.name)]
        )
    }
}

// MARK: - Project Helper

public enum TargetProvider {
    
    /// Generates all module targets
    public static func makeModuleTargets() -> [Target] {
        Module.allCases.flatMap { module in
            [module.makeTarget(), module.makeTestTarget()]
        }
    }
    
    /// Generates targets for specific modules
    public static func makeTargets(for modules: [Module]) -> [Target] {
        modules.flatMap { module in
            [module.makeTarget(), module.makeTestTarget()]
        }
    }
}

