import APIClient
import os

import ComposableArchitecture
import Model
import SwiftHelper
import UserDefaultsClient

public struct PomodoroTimerState: Equatable {
    public var isTimerActive = false
    public var pomodoroMode: PomodoroMode = .init(mode: .working, startDate: nil, endDate: nil)
    public var timerText = "00:00"
    public var timerSettings: PomodoroTimerSettings = .default
    public var finishedIntervalCount: Int = 0 // 終了した(.working状態の)インターバル数

    public init() {}

    public init(
        isTimerActive: Bool,
        pomodoroMode: PomodoroMode,
        timerText: String,
        timerSettings: PomodoroTimerSettings) {
            self.isTimerActive = isTimerActive
            self.pomodoroMode = pomodoroMode
            self.timerText = timerText
            self.timerSettings = timerSettings
        }
}

public extension PomodoroTimerState {
    struct PomodoroMode: Equatable {
        public enum Mode: CaseIterable, Equatable {
            case working
            case shortBreak
            case longBreak

            var name: String {
                switch self {
                case .working:
                    return "WORKING"
                case .shortBreak:
                    return "SHORT\nBREAK"
                case .longBreak:
                    return "LONG\nBREAK"
                }
            }
        }

        var mode: Mode
        var startDate: Date?
        var endDate: Date?

        mutating func goWorking() {
            self.mode = .working
            self.startDate = Date()
            self.endDate = nil
        }

        mutating func goShortBreak() {
            self.mode = .shortBreak
            self.startDate = Date()
            self.endDate = nil
        }

        mutating func goLongBreak() {
            self.mode = .longBreak
            self.startDate = Date()
            self.endDate = nil
        }
    }
}

public enum PomodoroTimerAction: Equatable {
    case nextPomodoroMode
    case saveHistory(PomodoroTimerHistory)
    case startTimer
    case stopTimer
    case timerTick
    case updatePomodoroSettings
    case reset

    case onAppear
    case onDisappear
}

public struct PomodoroTimerEnvironment {
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

public typealias PomodoroTimerReducer = Reducer<PomodoroTimerState, PomodoroTimerAction, PomodoroTimerEnvironment>

public let pomodoroTimerReducer = PomodoroTimerReducer { state, action, environment in
    struct TimerId: Hashable {}

    switch action {
    case .nextPomodoroMode:
        if state.pomodoroMode.mode == .working {
            state.finishedIntervalCount += 1
        }

        if state.finishedIntervalCount >= state.timerSettings.intervalCountBeforeLongBreak {
            // 長い休憩をとる条件は任意の回数(.working状態の)intervalを行うことである
            state.pomodoroMode.goLongBreak()
            state.finishedIntervalCount = 0
            return .none
        }

        switch state.pomodoroMode.mode {
        case .working:
            state.pomodoroMode.goShortBreak()
        case .shortBreak:
            state.pomodoroMode.goWorking()
        case .longBreak:
            state.pomodoroMode.goWorking()
        }

        // AppDelegateへ通知するためにNotificationCenterを利用しています
        NotificationCenter.default.post(name: .pomodoroModeChanged,
                                        object: nil,
                                        userInfo: [Notification.Name.UserInfoKey.pomodoroMode : state.pomodoroMode.mode])
        return .none
    case .saveHistory(let history):
        return environment.apiClient
            .savePomodoroHistory(history)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .fireAndForget()
    case .startTimer:
        state.isTimerActive = true
        if state.pomodoroMode.startDate == nil {
            state.pomodoroMode.startDate = Date()
        }
        return state.isTimerActive
        ? Effect.timer(
            id: TimerId(),
            every: 1,
            tolerance: .zero,
            on: environment.mainQueue
        )
            .map { _ in .timerTick }
        : Effect.cancel(id: TimerId())
    case .stopTimer:
        state.isTimerActive = false
        return Effect.cancel(id: TimerId())
    case .timerTick:
        switch state.pomodoroMode.mode {
        case .working:
            if state.timerSettings.intervalSeconds > 0 {
                state.timerSettings.intervalSeconds -= 1
                state.timerText = state.timerSettings.intervalMinutesSecond
                return .none
            }
        case .shortBreak:
            if state.timerSettings.shortBreakIntervalSeconds > 0 {
                state.timerSettings.shortBreakIntervalSeconds -= 1
                state.timerText = state.timerSettings.shortBreakIntervalMinutesSecond
                return .none
            }
        case .longBreak:
            if state.timerSettings.longBreakIntervalSeconds > 0 {
                state.timerSettings.longBreakIntervalSeconds -= 1
                state.timerText = state.timerSettings.longBreakIntervalMinutesSecond
                return .none
            }
        }

        // 残り時間が0である場合

        let endDate = Calendar.appCalendar.date(byAdding: .second, value: -1, to: Date()) // 01 → (1秒経過) → 00 → (1秒経過) → ここ、という流れなので0秒表示になってから1秒経過しているので-1をする
        state.pomodoroMode.endDate = endDate
        let finishedPomodoro: PomodoroTimerHistory = .init(
            startTime: .init(date: state.pomodoroMode.startDate!),
            endTime: .init(date: state.pomodoroMode.endDate!),
            category: ["demo"],
            pomodoroState: state.pomodoroMode.mode.name
        )

        return .concatenate(
            .init(value: .saveHistory(finishedPomodoro)),
            .init(value: .nextPomodoroMode),
            .init(value: .updatePomodoroSettings)
        )
    case .updatePomodoroSettings:
        state.timerSettings = environment.userDefaults.pomodoroTimerSettings
        switch state.pomodoroMode.mode {
        case .working:
            state.timerText = state.timerSettings.intervalMinutesSecond
        case .shortBreak:
            state.timerText = state.timerSettings.shortBreakIntervalMinutesSecond
        case .longBreak:
            state.timerText = state.timerSettings.longBreakIntervalMinutesSecond
        }
        return .none
    case .reset:
        state.pomodoroMode.goWorking()
        state.finishedIntervalCount = 0

        return .concatenate(
            .init(value: .stopTimer),
            .init(value: .updatePomodoroSettings)
        )
    case .onAppear:
        return .init(value: .updatePomodoroSettings)
    case .onDisappear:
        return .none
    }
}
