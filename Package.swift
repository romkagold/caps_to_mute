
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MuteWithCapsLock",
    dependencies: [
        .package(url: "https://github.com/rnine/SimplyCoreAudio.git", from: "3.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "MuteWithCapsLock",
            dependencies: ["SimplyCoreAudio"]),
    ]
)

