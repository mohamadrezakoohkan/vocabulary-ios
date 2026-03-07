import ProjectDescription

let tuist = Tuist.init(
    fullHandle: "work.koohkan/drova-ios",
    project: .tuist(
        compatibleXcodeVersions: .all,
        swiftVersion: nil,
        plugins: [],
        generationOptions: Tuist.GenerationOptions.options(),
        installOptions: Tuist.InstallOptions.options(),
        cacheOptions: .options()
    )
)
