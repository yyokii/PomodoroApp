import SwiftUI

import ComposableArchitecture

struct PomodoroTimerSettingsView: View {
    let store: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction>

    init (store: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Picker("interval", selection: viewStore.binding(\.$intervalTime)) {
                    ForEach(1..<60) { minutes in
                        Text("\(minutes)")
                    }
                }

                Picker("shortBreakTime", selection: viewStore.binding(\.$shortBreakTime)) {
                    ForEach(1..<60) { minutes in
                        Text("\(minutes)")
                    }
                }

                Picker("longBreakTime", selection: viewStore.binding(\.$longBreakTime)) {
                    ForEach(1..<60) { minutes in
                        Text("\(minutes)")
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
