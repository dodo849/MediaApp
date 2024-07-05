import ProjectDescription

extension Settings {
    public enum SettingsType: String {
        case base
        case network
        
        public var name: ConfigurationName {
            return ConfigurationName.configuration(self.rawValue)
        }
    }
    
    public static func settings(_ type: SettingsType) -> Settings {
        switch type {
        case .base:
            return .settings(
                configurations: [
                    .debug(name: "dev"),
                    .release(name: "prod")
                ],
                defaultSettings: .recommended
            )
        case .network:
            return .settings(
                configurations: [
                    .debug(
                        name: "dev",
                        xcconfig: .relativeToRoot("Xcconfigs/APIConfig.xcconfig")
                    ),
                    .release(
                        name: "prod",
                        xcconfig: .relativeToRoot("Xcconfigs/APIConfig.xcconfig")
                    )
                ],
                defaultSettings: .recommended
            )
        }
    }
}
