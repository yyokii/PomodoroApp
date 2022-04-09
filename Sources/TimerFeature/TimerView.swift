import SwiftUI

import APIClient
import ComposableArchitecture

public struct TimerView: View {
    public var store: Store<PomodoroTimerState, PomodoroTimerAction>

    public init(store: Store<PomodoroTimerState, PomodoroTimerAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("State: \(viewStore.pomodoroMode.name)")
                Text(viewStore.timerText)
                    .padding()

                if viewStore.isTimerActive {
                    Button("Stop") {
                        viewStore.send(.stopTimer)
                    }
                } else {
                    Button("Start") {
                        viewStore.send(.startTimer)
                    }
                }
            }
            .onAppear {
                viewStore.send(.startTimer)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(store: .init(
            initialState: .init(
                isTimerActive: false,
                pomodoroMode: .working,
                timerText: "00:00",
                timerSettings: .default()
            ),
            reducer: pomodoroTimerReducer,
            environment: .init(
                apiClient: FirebaseAPIClient.live,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        ))
            .previewInterfaceOrientation(.portrait)
    }
}
