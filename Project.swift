import ProjectDescription
import ProjectDescriptionHelpers

let modules: [any Module] = AppModule.allCases + FeatureModule.allCases + SharedModule.allCases + CoreModule.allCases
let targets: [ProjectDescription.Target] = modules.flatMap(\.targets)

let project = Project(
    name: "Vocabulary",
    targets: targets,
    additionalFiles: [
        "CLAUDE.md",
        ".cursor",
        ".gitignore"
    ]
)
