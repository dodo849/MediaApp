import SwiftUI

import NavigationDI
import ScrapFeature

import ComposableArchitecture

@main
struct MediaApp: App {
    var navigationStore = Store(
        initialState: NavigationFeature.State()
    ) {
        NavigationFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView(
                store: navigationStore
            ) {
                ScrapView(
                    store: navigationStore.scope(
                        state: \.destination?.scrap ?? ScrapFeature.State(), // 기본값 설정
                        action: \.destination.scrap ?? .init()
                    )
                )
            }
        }
    }
}

struct NavigationEnvironmentKey: EnvironmentKey {
    static let defaultValue: StoreOf<NavigationFeature> = Store(
        initialState: NavigationFeature.State()
    ) {
        NavigationFeature()
    }
}

extension EnvironmentValues {
    var navigationStore: StoreOf<NavigationFeature> {
        get { self[NavigationEnvironmentKey.self] }
        set { self[NavigationEnvironmentKey.self] = newValue }
    }
}
