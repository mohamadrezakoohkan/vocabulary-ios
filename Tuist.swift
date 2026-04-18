import ProjectDescription

let tuist = Tuist.init(
    fullHandle: "vocabulary/vocabulary-ios",
    project: .tuist(
        compatibleXcodeVersions: .all,
        swiftVersion: nil,
        plugins: [],
        generationOptions: Tuist.GenerationOptions.options(),
        installOptions: Tuist.InstallOptions.options(),
        cacheOptions: .options()
    )
)
