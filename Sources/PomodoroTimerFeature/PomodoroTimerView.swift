import SwiftUI

import APIClient
import ComposableArchitecture
import MyDataFeature
import Styleguide
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
                HStack {
                    Text("\(viewStore.pomodoroMode.mode.name)")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(.appBlack)
                        .frame(width: 70, height: 24)
                        .padding(.leading, 22)
                    Text(viewStore.timerText)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.appBlack)
                        .frame(width: 120, height: 40)
                        .padding(.leading, 5)
                    Button {
                        viewStore.send(.reset)
                    } label: {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .frame(width: 16, height: 20)
                            .foregroundColor(.appBlack)
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                }

                Button {
                    if viewStore.isTimerActive {
                        viewStore.send(.stopTimer)
                    } else {
                        viewStore.send(.startTimer)
                    }
                } label: {
                    Text(viewStore.isTimerActive ? "STOP" : "START")
                        .frame(width: 80, height: 24)
                        .font(.system(size: 13))
                        .foregroundColor(.appWhite)
                        .background(Color.appBlack)
                        .cornerRadius(8)
                }
                .buttonStyle(.borderless)

//                Button("Open Data View") {
//                    MyDataView(store: myDataStore)
//                        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
//                        .openInWindow(title: "Data View", sender: self)
//                }
            }
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
            timerSettings: .default
        ),
        reducer: pomodoroTimerReducer,
        environment: .init(
            apiClient: .live,
            userDefaults: .live(),
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
