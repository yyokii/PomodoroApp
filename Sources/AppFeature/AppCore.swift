import Combine
import os

import APIClient
import ComposableArchitecture
import AccountFeature
import Model
import MyDataFeature
import PomodoroTimerFeature
import SwiftHelper
import Settings
import UserDefaultsClient

public struct AppState: Equatable {
    var account: AccountState = AccountState()
    var myData: MyDataState = MyDataState()
    var pomodoroTimer: PomodoroTimerState = PomodoroTimerState()
    public var settings: SettingsState = SettingsState()

    public init() {}
}

public enum AppAction: Equatable {
    case account(AccountAction)
    case myData(MyDataAction)
    case pomodoroTimer(PomodoroTimerAction)
    case settings(SettingsAction)

    case checkUserStatusResponse(Result<AppUser, Never>)
    case signInAnonymouslyResponse(Result<None, APIError>)

    case onAppear
    case onDisappear
}

public struct AppEnvironment {
    var apiClient: FirebaseAPIClient
    var userDefaults: UserDefaultsClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        apiClient: FirebaseAPIClient,
        userDefaults: UserDefaultsClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.apiClient = apiClient
        self.userDefaults = userDefaults
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
                userDefaults: environment.userDefaults,
                mainQueue: environment.mainQueue
            )
        }
    ),
    settingsReducer.pullback(
        state: \AppState.settings,
        action: /AppAction.settings,
        environment: { environment in
            SettingsEnvironment(
                mainQueue: environment.mainQueue
            )
        }
    ),
    .init { state, action, environment in

        struct AccountCancelId: Hashable {}

        switch action {
        case .account:
            return .none
        case .myData:
            return .none
        case .pomodoroTimer:
            return .none
        case .settings:
            return .none
        case .checkUserStatusResponse(.success(let appUser)):
            if appUser.status == .uninitialized {
                OSLog.debug("User not signed in.")
                return environment.apiClient
                    .signInAnonymously()
                    .receive(on: environment.mainQueue)
                    .catchToEffect()
                    .map(AppAction.signInAnonymouslyResponse)
                    .cancellable(id: AccountCancelId())

            } else {
                OSLog.debug("User signed in.\nUser status:\(appUser.status)\nUser ID: \(appUser.id)\n")
                return .none
            }
        case .signInAnonymouslyResponse(.success):
            OSLog.debug("Anonymously signed in.")
            return .none
        case .signInAnonymouslyResponse(.failure):
            return .none
        case .onAppear:
            return environment.apiClient
                .checkUserStatus()
                .receive(on: environment.mainQueue)
                .catchToEffect()
                .map(AppAction.checkUserStatusResponse)
        case .onDisappear:
            return .none
        }
    }
)
