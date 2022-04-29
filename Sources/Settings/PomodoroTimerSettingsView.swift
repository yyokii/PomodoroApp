import SwiftUI

import ComposableArchitecture

struct PomodoroTimerSettingsView: View {
    let store: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction>

    init (store: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .center) {

                HStack {
                    Text("Interval time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$intervalTime)) {
                        ForEach(1..<60) { minutes in
                            Text("\(minutes)")
                        }
                    }
                }

                HStack {
                    Text("Short break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$shortBreakTime)) {
                        ForEach(1..<61) { minutes in
                            Text("\(minutes)")
                        }
                    }
                }

                HStack {
                    Text("Long break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$longBreakTime)) {
                        ForEach(1..<61) { minutes in
                            Text("\(minutes)")
                        }
                    }
                }

                HStack {
                    Text("Long break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$intervalCountBeforeLongBreak)) {
                        ForEach(0..<11) { minutes in
                            Text("\(minutes)")
                        }
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
