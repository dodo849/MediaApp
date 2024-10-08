// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Alamofire": .framework,
        "RealmSwift": .staticFramework,
        "Dependencies": .framework,
        "Kingfisher": .framework
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
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.11.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.50.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
    ]
)
