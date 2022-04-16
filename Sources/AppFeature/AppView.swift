
import SwiftUI

import ComposableArchitecture
import MyDataFeature
import PomodoroTimerFeature

#warning("不要かもしれない")

struct AppView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            
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
