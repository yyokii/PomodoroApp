import APIClient
import ComposableArchitecture
import AccountFeature
import MyDataFeature
import PomodoroTimerFeature

struct AppState: Equatable {
    var account: AccountState
    var myData: MyDataState
    var pomodoroTimer: PomodoroTimerState
}

public enum AppAction: Equatable {
    case account(AccountAction)
    case myData(MyDataAction)
    case pomodoroTimer(PomodoroTimerAction)
}

struct AppEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    accountReducer.pullback(
        state: \AppState.account,
        action: /AppAction.account,
        environment: { environment in
            AccountEnvironment(
                apiClient: environment.apiClient,
                mainQueue: environment.mainQueue
            )
        }
    ),
    accountReducer.pullback(
        state: \AppState.account,
        action: /AppAction.account,
        environment: { environment in
            AccountEnvironment(
                apiClient: environment.apiClient,
                mainQueue: environment.mainQueue
            )
        }
    ),
    accountReducer.pullback(
        state: \AppState.account,
        action: /AppAction.account,
        environment: { environment in
            AccountEnvironment(
                apiClient: environment.apiClient,
                mainQueue: environment.mainQueue
            )
        }
    ),
    .init { state, action, environment in
        switch action {
        case .account:
            return .none
        case .myData:
            return .none
        case .pomodoroTimer:
            return .none
        }
    }
)
