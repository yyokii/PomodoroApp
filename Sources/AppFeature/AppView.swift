
import SwiftUI

import ComposableArchitecture
import MyDataFeature
import PomodoroTimerFeature
import Settings
import Styleguide

public struct AppView: View {
    let store: Store<AppState, AppAction>

    public init (store: Store<AppState, AppAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Spacer()

                    Button {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                        NSApp.activate(ignoringOtherApps: true)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.appBlack)
                    }
                    .buttonStyle(.borderless)
                    .padding(.trailing, 8)

                }
                PomodoroTimerView(pomodoroTimerStore: pomodoroTimerStore,
                                  myDataStore: myDataStore)
            }
            .frame(width: 320, height: 120)
            .background(Color.appGray)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
// MARK: - Store inits

extension AppView {
    private var myDataStore: Store<MyDataState, MyDataAction> {
        return store.scope(
            state: { $0.myData },
            action: AppAction.myData
        )
    }

    private var pomodoroTimerStore: Store<PomodoroTimerState, PomodoroTimerAction> {
        return store.scope(
            state: { $0.pomodoroTimer },
            action: AppAction.pomodoroTimer
        )
    }
}
