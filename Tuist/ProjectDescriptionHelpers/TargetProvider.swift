//
//  ProjectProvider.swift
//  Manifests
//
//  Created by Mohammad reza on 7/3/26.
//

import ProjectDescription


// MARK: - Module Target Generation

extension Module {

    public var targets: [Target] {
        let productTarget: Target? = includeProductTarget ? makeTarget() : nil
        let testTarget: Target? = includeTestTarget ? makeTestTarget() : nil
        let exampleTarget: Target? = includeExampleTarget ? makeExampleTarget() : nil
        return [productTarget, testTarget, exampleTarget].compactMap { $0 }
    }

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
    private func makeTarget() -> Target {
        .target(
            name: rawValue,
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

    /// Generates a Example Target for this module
    ///
    private func makeExampleTarget() -> Target {
        .target(
            name: "\(rawValue)Example",
            destinations: .iOS,
            product: .app,
            bundleId: "\(bundleId)Example",
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [
                    "UIColorName": "",
                    "UIImageName": "",
                ],
            ]),
            buildableFolders: [
                .folder(.path(examplePath)),
            ],
            dependencies: rawValue == CoreModule.coreUI.rawValue ? [.target(name: rawValue)] : [.target(name: rawValue), .target(name: SharedModule.sharedExample.rawValue)]
        )
    }

    /// Generates a test Target for this module
    /// 
    private func makeTestTarget() -> Target {
        .target(
            name: "\(rawValue)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId)Tests",
            buildableFolders: [.folder(.path(testsPath))],
            dependencies: [.target(name: rawValue), .target(name: SharedModule.sharedTesting.rawValue)]
        )
    }
}
