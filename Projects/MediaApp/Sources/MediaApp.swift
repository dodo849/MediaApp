import SwiftUI

import ScrapFeature

import ComposableArchitecture

@main
struct MediaApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrapView(
                    store: Store(initialState: ScrapFeature.State()) {
                        ScrapFeature()
                    }
                )
            }
        }
    }
}
