import SwiftUI

import APIClient
import MyDataFeature
import ComposableArchitecture
import SwiftHelper

public struct PomodoroTimerView: View {
    public var store: Store<PomodoroTimerState, PomodoroTimerAction>

    let demoMyDataView = MyDataView(store: .init(initialState: .init(),
                                                 reducer: myDataReducer,
                                                 environment: .init(apiClient: FirebaseAPIClient.live,
                                                                    mainQueue: DispatchQueue.main.eraseToAnyScheduler())
                                                ))

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

                Button("Open Data View") {
                    demoMyDataView
                        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
                        .openInWindow(title: "Data View", sender: self)
                }
            }
            .frame(width: 350, height: 500)
            .onAppear {
                viewStore.send(.startTimer)
            }
        }
    }
}

extension PomodoroTimerView {
    public static var demoView = PomodoroTimerView(store: .init(
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
        )))
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView(store: .init(
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
            )))
            .previewInterfaceOrientation(.portrait)
    }
}
