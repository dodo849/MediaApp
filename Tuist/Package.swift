// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Alamofire": .framework
    ],
    baseSettings: .settings(
        configurations: [
            .debug(name: "dev"),
            .debug(name: "prod")
        ]
    )
)
#endif

let package = Package(
    name: "MediaApp",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.11.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
    ]
)
