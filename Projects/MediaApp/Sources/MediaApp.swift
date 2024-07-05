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
                //                ContentView()
                ScrapView(
                    store: Store(
                        initialState: ScrapFeature.State()
                    ) {
                        ScrapFeature()
                    }
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .environment(\.navigationStore, navigationStore)
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
