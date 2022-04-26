import ComposableArchitecture
import UserDefaultsClient

// MARK: Settings

public struct PomodoroTimerSettingsState: Equatable {
    var intervalTime: String = "0"
    var shortBreakTime: String = "0"
    var longBreaklTime: String = "0"

    public init() {}
}

public enum PomodoroTimerSettingsAction: Equatable {
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
        case .onAppear:
            let settings = environment.userDefaults.pomodoroTimerSettings
            state.intervalTime = "\(settings.intervalTime)"
            state.shortBreakTime = "\(settings.shortBreakTime)"
            state.longBreaklTime = "\(settings.longBreakTime)"
            return .none
        case .onDisappear:
            return .none
        }
    }
)

// MARK: Settings

public struct SettingsState: Equatable {

    public init() {}
}

public enum SettingsAction: Equatable {
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
    .init { state, action, environment in

        switch action {
        case .onAppear:
            return .none
        case .onDisappear:
            return .none
        }
    }
)
