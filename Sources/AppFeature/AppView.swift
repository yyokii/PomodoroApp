
import SwiftUI

import ComposableArchitecture
import MyDataFeature
import PomodoroTimerFeature

public struct AppView: View {
    let store: Store<AppState, AppAction>

    public init (store: Store<AppState, AppAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            PomodoroTimerView(pomodoroTimerStore: pomodoroTimerStore,
                              myDataStore: myDataStore)
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
