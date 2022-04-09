import APIClient

import ComposableArchitecture
import SwiftHelper

public struct PomodoroTimerState: Equatable {
    var isTimerActive = false
    var pomodoroMode: PomodoroMode = .working
    var timerText = "00:00"
    var timerSettings: TimerSettings = .default()

    enum PomodoroMode: CaseIterable, Equatable {
        case working
        case shortBreak
        case longBreak

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
    case startTimer
    case stopTimer
    case timerTick
}

struct PomodoroTimerEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

typealias PomodoroTimerReducer = Reducer<PomodoroTimerState, PomodoroTimerAction, PomodoroTimerEnvironment>

let pomodoroTimerReducer = PomodoroTimerReducer { state, action, environment in
    struct TimerId: Hashable {}

    switch action {
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

        // 設定しているタイマーが0までカウントダウンした場合
        state.pomodoroMode = state.pomodoroMode.next()
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
    }
}
