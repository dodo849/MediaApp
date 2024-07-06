public enum Module {
    public enum Feature: String, CaseIterable {
        case common = "Common"
        case search = "Search"
        case scrap = "Scrap"
    }

    public enum Core: String, CaseIterable {
        case cache = "Cache"
        case network = "Network"
    }
    
    public enum Network: String, CaseIterable {
        case common = "Common"
        case media = "Media"
    }
    
    public enum Database: String, CaseIterable {
        case common = "Common"
        case media = "Media"
    }
    
    public enum DI: String, CaseIterable {
        case navigation = "Navigation"
    }
    
    public enum ThirdParty: String {
        case composableArchitecture = "ComposableArchitecture"
        case alamofire = "Alamofire"
        case realm = "RealmSwift"
        case swiftDependencies = "Dependencies"
    }

}
