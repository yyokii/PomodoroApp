import APIClient
import os

import ComposableArchitecture
import Model
import SwiftHelper

public struct PomodoroTimerState: Equatable {
    public var isTimerActive = false
    public var pomodoroMode: PomodoroMode = .working
    public var timerText = "00:00"
    public var timerSettings: PomodoroTimerSettings = .default()

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

extension PomodoroTimerState {
    public enum PomodoroMode: CaseIterable, Equatable {
        case working
        case shortBreak
        case longBreak

        #warning("ローカライズ対応")
        var name: String {
            switch self {
            case .working:
                return "作業中"
            case .shortBreak:
                return "短い休憩"
            case .longBreak:
                return "長い休憩"
            }
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

    case onAppear
    case onDisappear
}

public struct PomodoroTimerEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(apiClient: FirebaseAPIClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.apiClient = apiClient
        self.mainQueue = mainQueue
    }
}

public typealias PomodoroTimerReducer = Reducer<PomodoroTimerState, PomodoroTimerAction, PomodoroTimerEnvironment>

public let pomodoroTimerReducer = PomodoroTimerReducer { state, action, environment in
    struct TimerId: Hashable {}

    switch action {
    case .nextPomodoroMode:
        state.pomodoroMode = state.pomodoroMode.next()
        return .none
    case .saveHistory(let history):
        return environment.apiClient
            .savePomodoroHistory(history)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .fireAndForget()
    case .startTimer:
        state.isTimerActive = true
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
        switch state.pomodoroMode {
        case .working:
            if state.timerSettings.intervalSeconds > 0 {
                state.timerSettings.intervalSeconds -= 1
                state.timerText = state.timerSettings.intervalMinutesSecond
                return .none
            }
        case .shortBreak:
            if state.timerSettings.shortBreakIntervalSeconds > 0 {
                state.timerSettings.shortBreakIntervalSeconds -= 1
                state.timerText = state.timerSettings.shortBreakIntervalSecondsMinutesSecond
                return .none
            }
        case .longBreak:
            if state.timerSettings.longBreakIntervalSeconds > 0 {
                state.timerSettings.longBreakIntervalSeconds -= 1
                state.timerText = state.timerSettings.longBreakIntervalSecondsMinutesSecond
                return .none
            }
        }

        OSLog.debug("Change pomodoro status")
        let finishedPomodoro: PomodoroTimerHistory = .init(
            startTime: .init(date: Date()),
            endTime: .init(date: Date()),
            category: ["demo"],
            pomodoroState: "demo"
        )
        return .concatenate(
            .init(value: .saveHistory(finishedPomodoro)),
            .init(value: .nextPomodoroMode),
            .init(value: .updatePomodoroSettings)
        )
    case .updatePomodoroSettings:
#warning("タイマー設定を設定画面から取得して設定し直す。現状固定値を設定")
        state.timerSettings = .init(intervalSeconds: 5, shortBreakIntervalSeconds: 6, longBreakIntervalSeconds: 7)
        switch state.pomodoroMode {
        case .working:
            state.timerText = state.timerSettings.intervalMinutesSecond
        case .shortBreak:
            state.timerText = state.timerSettings.shortBreakIntervalSecondsMinutesSecond
        case .longBreak:
            state.timerText = state.timerSettings.longBreakIntervalSecondsMinutesSecond
        }
        return .none
    case .onAppear:
        return .init(value: .startTimer)
    case .onDisappear:
        return .none
    }
}
