import SwiftUI

import ComposableArchitecture

struct PomodoroTimerSettingsView: View {
    let store: Store<PomodoroTimerSettingsState, PomodoroTimerSettingsAction>
    let selectableNumbers: [Int] = Array(1...60)

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
                        ForEach(0..<selectableNumbers.count) { index in
                            Text("\(selectableNumbers[index])")
                                .tag(selectableNumbers[index])
                        }
                    }
                }

                HStack {
                    Text("Short break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$shortBreakTime)) {
                        ForEach(0..<selectableNumbers.count) { index in
                            Text("\(selectableNumbers[index])")
                                .tag(selectableNumbers[index])
                        }
                    }
                }

                HStack {
                    Text("Long break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$longBreakTime)) {
                        ForEach(0..<selectableNumbers.count) { index in
                            Text("\(selectableNumbers[index])")
                                .tag(selectableNumbers[index])
                        }
                    }
                }

                HStack {
                    Text("Long break time (minutes)")
                        .frame(width: 200, alignment: .trailing)

                    Picker("", selection: viewStore.binding(\.$intervalCountBeforeLongBreak)) {
                        ForEach(0..<11) { index in
                            Text("\(index)")
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
