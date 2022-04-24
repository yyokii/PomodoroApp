import SwiftUI

import APIClient
import ComposableArchitecture
import MyDataFeature
import SwiftHelper

public struct PomodoroTimerView: View {
    let pomodoroTimerStore: Store<PomodoroTimerState, PomodoroTimerAction>

    let myDataStore: Store<MyDataState, MyDataAction>

    public init(pomodoroTimerStore: Store<PomodoroTimerState, PomodoroTimerAction>,
                myDataStore: Store<MyDataState, MyDataAction>) {
        self.pomodoroTimerStore = pomodoroTimerStore
        self.myDataStore = myDataStore
    }

    public var body: some View {
        WithViewStore(pomodoroTimerStore) { viewStore in
            VStack {
                Text("State: \(viewStore.pomodoroMode.mode.name)")
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
                    MyDataView(store: myDataStore)
                        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
                        .openInWindow(title: "Data View", sender: self)
                }
            }
            .frame(width: 350, height: 500)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#if DEBUG

struct PomodoroTimerView_Previews: PreviewProvider {
    static let pomodoroTimerStore: Store<PomodoroTimerState, PomodoroTimerAction> = .init(
        initialState: .init(
            isTimerActive: false,
            pomodoroMode: .init(mode: .working, startDate: nil, endDate: nil),
            timerText: "00:00",
            timerSettings: .default()
        ),
        reducer: pomodoroTimerReducer,
        environment: .init(
            apiClient: FirebaseAPIClient.live,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()))

    static let myDataStore: Store<MyDataState, MyDataAction> = .init(
        initialState: .init(),
        reducer: myDataReducer,
        environment: .init(apiClient: FirebaseAPIClient.live,
                           mainQueue: DispatchQueue.main.eraseToAnyScheduler()))

    static var previews: some View {
        PomodoroTimerView(pomodoroTimerStore: pomodoroTimerStore,
                          myDataStore: myDataStore)
            .previewInterfaceOrientation(.portrait)
    }
}

#endif
