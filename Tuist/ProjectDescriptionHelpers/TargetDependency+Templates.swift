import ProjectDescription

public extension TargetDependency {
    static func feature(
        _ target: Module.Feature
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)Feature",
            path: .relativeToRoot("Projects/Feature/\(target.rawValue)")
        )
    }
    
    static func core(
        _ target: Module.Core
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)Core",
            path: .relativeToRoot("Projects/Core/\(target.rawValue)")
        )
    }
    
    static func network(
        _ target: Module.Network
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)Network",
            path: .relativeToRoot("Projects/Network/\(target.rawValue)")
        )
    }
    
    static func di(
        _ target: Module.DI
    ) -> TargetDependency {
        return .project(
            target: "\(target.rawValue)DI",
            path: .relativeToRoot("Projects/DI/\(target.rawValue)")
        )
    }
    
    static func thirdParty(
        _ target: Module.ThirdParty
    ) -> TargetDependency {
        return .external(name: "\(target.rawValue)")
    }
}
