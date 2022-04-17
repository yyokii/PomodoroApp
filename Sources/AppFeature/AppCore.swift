import APIClient
import ComposableArchitecture
import AccountFeature
import MyDataFeature
import PomodoroTimerFeature

public struct AppState: Equatable {
    var account: AccountState = AccountState()
    var myData: MyDataState = MyDataState()
    var pomodoroTimer: PomodoroTimerState = PomodoroTimerState()

    public init() {}
}

public enum AppAction: Equatable {
    case account(AccountAction)
    case myData(MyDataAction)
    case pomodoroTimer(PomodoroTimerAction)
}

public struct AppEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        apiClient: FirebaseAPIClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.apiClient = apiClient
        self.mainQueue = mainQueue
    }
}

public let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
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
    myDataReducer.pullback(
        state: \AppState.myData,
        action: /AppAction.myData,
        environment: { environment in
            MyDataEnvironment (
                apiClient: environment.apiClient,
                mainQueue: environment.mainQueue
            )
        }
    ),
    pomodoroTimerReducer.pullback(
        state: \AppState.pomodoroTimer,
        action: /AppAction.pomodoroTimer,
        environment: { environment in
            PomodoroTimerEnvironment(
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
