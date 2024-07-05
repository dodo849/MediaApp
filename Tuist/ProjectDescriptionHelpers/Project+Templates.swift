import ProjectDescription

extension Project {
    public static let deployTarget = 15.0
    public static let bundleId = "com.meadia.app"
    
    public static func makeMainApp(name: String) -> Project {
        return Project(
            name: "\(name)",
            settings: .settings(.base),
            targets: [
                makeTarget(
                    name: "\(name)",
                    product: .app,
                    bundleId: "\(bundleId).app",
                    infoPlist: .default,
                    dependencies: [
                        .feature(.scrap),
                        .feature(.search)
                    ] + uiDependencies
                ),
                makeTarget(
                    name: "\(name)Tests",
                    product: .unitTests,
                    bundleId: "\(bundleId).app.tests",
                    dependencies: [.target(name: "\(name)")]
                )
            ]
        )
    }
    
    public static func makeFeatureModule(
        _ target: Module.Feature,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let name = target.rawValue
        return Project(
            name: "\(name)",
            settings: .settings(.base),
            targets: [
                makeTarget(
                    name: "\(name)",
                    product: .framework,
                    bundleId: "\(bundleId).\(name).feature",
                    infoPlist: .default,
                    hasResource: true,
                    dependencies: dependencies + uiDependencies
                ),
            ]
        )
    }
    
    public static func makeCoreModule(
        _ target: Module.Core,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let name = target.rawValue
        return Project(
            name: "\(name)",
            settings: .settings(.base),
            targets: [
                makeTarget(
                    name: "\(name)",
                    product: .framework,
                    bundleId: "\(bundleId).\(name).core",
                    dependencies: dependencies
                ),
            ]
        )
    }
    
    public static func makeNetworkModule(
        _ target: Module.Network,
        dependencies: [TargetDependency] = []
    ) -> Project {
        let name = target.rawValue
        return Project(
            name: "\(name)",
            settings: .settings(.network),
            targets: [
                makeTarget(
                    name: "\(name)",
                    product: .framework,
                    bundleId: "\(bundleId).\(name).network",
                    dependencies: dependencies
                ),
            ]
        )
    }
}

// MARK: - Target
extension Project {
    static func makeTarget(
        name: String,
        product: Product,
        bundleId: String,
        infoPlist: InfoPlist? = .default,
        hasResource: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: [.iPhone],
            product: product,
            bundleId: bundleId,
            deploymentTargets: .iOS("\(Project.deployTarget)"),
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            scripts: [.swiftlint],
            dependencies: dependencies
        )
    }
}


// MARK: - Info.plist
extension Project {
    static let dataInfoPlist: [String: Plist.Value] = [
        "API_BASE_URL": "$(API_BASE_URL)",
    ]
}

// MARK: - Dependencies {
extension Project {
    static let uiDependencies: [TargetDependency] = [
        .thirdParty(.composableArchitecture)
    ]
    
    static let netowrkDependencies: [TargetDependency] = [
        .thirdParty(.alamofire)
    ]
}
