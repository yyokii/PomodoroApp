import SwiftUI

import ComposableArchitecture

public struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>

    public init (store: Store<SettingsState, SettingsAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                PomodoroTimerSettingsView(store: pomodoroTimerSettingsStore)
                    .tabItem {
                        Label("General", systemImage: "gear")
                    }
                    .navigationTitle("ParentTitle")
                    .navigationSubtitle("General")
                Text("Advanced")
                    .tabItem {
                        Label("Advanced", systemImage: "star")
                    }
                    .navigationTitle("ParentTitle")
                    .navigationSubtitle("Advanced")
            }
            .padding(20)
            .frame(width: 375, height: 150)

        }
    }
}

extension SettingsView {
    private var pomodoroTimerSettingsStore: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction> {
        return store.scope(
            state: { $0.pomodoroTimerSettings },
            action: SettingsAction.pomodoroTimerSettings
        )
    }
}
