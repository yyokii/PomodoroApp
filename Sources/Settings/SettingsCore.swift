import os

import ComposableArchitecture
import UserDefaultsClient
import SwiftHelper

// MARK: Settings

public struct PomodoroTimerSettingsState: Equatable {
    // ユーザーが設定する「minutes」単位のポモドーロの各時間
    @BindableState var intervalTime: Int = 0
    @BindableState var shortBreakTime: Int = 0
    @BindableState var longBreakTime: Int = 0

    public init() {}
}

public enum PomodoroTimerSettingsAction: Equatable, BindableAction {
    case binding(BindingAction<PomodoroTimerSettingsState>)
    case onAppear
    case onDisappear
}

public struct PomodoroTimerSettingsEnvironment {
    var userDefaults: UserDefaultsClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        userDefaults: UserDefaultsClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
        self.userDefaults = userDefaults
    }
}

public let pomodoroTimerSettingsReducer: Reducer<PomodoroTimerSettingsState, PomodoroTimerSettingsAction, PomodoroTimerSettingsEnvironment> = .combine(
    .init { state, action, environment in
        switch action {
        case .binding:
            return environment.userDefaults.setPomodoroTimerSettings(.init(
                intervalSeconds: state.intervalTime * 60,
                shortBreakIntervalSeconds: state.shortBreakTime * 60,
                longBreakIntervalSeconds: state.longBreakTime * 60)
            )
                .fireAndForget()
        case .onAppear:
            let settings = environment.userDefaults.pomodoroTimerSettings
            state.intervalTime = settings.intervalSeconds / 60
            state.shortBreakTime = settings.shortBreakIntervalSeconds / 60
            state.longBreakTime = settings.longBreakIntervalSeconds / 60
            return .none
        case .onDisappear:
            return .none
        }
    }
).binding()


// MARK: Settings

public struct SettingsState: Equatable {
    var pomodoroTimerSettings: PomodoroTimerSettingsState = PomodoroTimerSettingsState()

    public init() {}
}

public enum SettingsAction: Equatable {
    case pomodoroTimerSettings(PomodoroTimerSettingsAction)

    case onAppear
    case onDisappear
}

public struct SettingsEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
    }
}

public let settingsReducer: Reducer<SettingsState, SettingsAction, SettingsEnvironment> = .combine(
    pomodoroTimerSettingsReducer.pullback(
        state: \SettingsState.pomodoroTimerSettings,
        action: /SettingsAction.pomodoroTimerSettings,
        environment: { environment in
            PomodoroTimerSettingsEnvironment(
                userDefaults: .live(),
                mainQueue: environment.mainQueue)
        }
    ),

        .init { state, action, environment in

            switch action {
            case .pomodoroTimerSettings:
                return .none
            case .onAppear:
                return .none
            case .onDisappear:
                return .none
            }
        }
)
