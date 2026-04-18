import ProjectDescription
import ProjectDescriptionHelpers

let modules: [any Module] = AppModule.allCases + FeatureModule.allCases + SharedModule.allCases + CoreModule.allCases

let targets: [ProjectDescription.Target] = modules.flatMap { module in
    if module is FeatureModule {
        [module.makeTarget(), module.makeExampleTarget(), module.makeTestTarget()]
    } else {
        [module.makeTarget(), module.makeTestTarget()]
    }
}

let project = Project(
    name: "Vocabulary",
    targets: targets,
    additionalFiles: [
        "CLAUDE.md",
        ".cursor",
        ".gitignore"
    ]
)
