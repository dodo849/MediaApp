import ProjectDescription

public extension TargetDependency {
    static func feature(
        _ target: Module.Feature
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)",
            path: .relativeToRoot("Projects/Feature/\(target.rawValue)")
        )
    }
    
    static func core(
        _ target: Module.Core
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)",
            path: .relativeToRoot("Projects/Core/\(target.rawValue)")
        )
    }
    
    static func network(
        _ target: Module.Network
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)",
            path: .relativeToRoot("Projects/Network/\(target.rawValue)")
        )
    }
    
    static func thirdParty(
        _ target: Module.ThirdParty
    ) -> TargetDependency {
        return .external(name: "\(target.rawValue)")
    }
}
