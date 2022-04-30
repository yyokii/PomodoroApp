import SwiftUI

import Settings
import AppFeature
import ComposableArchitecture

@main
struct MacOSApp: App {
    init() {}

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {

        WithViewStore(settingsStore) { viewStore in
            Settings {
                SettingsView(store: settingsStore)
            }
        }
    }
}

