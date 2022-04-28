import SwiftUI

import Settings

@main
struct MacOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView(store: .init(initialState: SettingsState(),
                                      reducer: settingsReducer,
                                      environment: .init(
                                        mainQueue: DispatchQueue.main.eraseToAnyScheduler())
                                     )
            )
        }
    }
}

