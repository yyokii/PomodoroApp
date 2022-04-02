import Combine
import Foundation.NSTimer

import SwiftHelper

enum PomodoroState: CaseIterable {
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

enum TimerState {
    case start
    case stop
}

final class TimerViewModel: ObservableObject {
    @Published var pomodoroState: PomodoroState = .working
    @Published var timerState: TimerState = .start
    @Published var timerText: String = "00:00"
    
    var timerSettings: TimerSettings = .default()
    
    private var timer: Timer!
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        timerText = timerSettings.intervalMinutesSecond
    }
    
    func startTimer() {
        timer = Timer(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.timerUpdate(with: self.pomodoroState)
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func timerUpdate(with state: PomodoroState) {
        switch state {
        case .working:
            if self.timerSettings.intervalSeconds > 0 {
                self.timerSettings.intervalSeconds -= 1
                self.timerText = timerSettings.intervalMinutesSecond
                return
            }
        case .shortBreak:
            if self.timerSettings.shortBreakIntervalSeconds > 0 {
                self.timerSettings.shortBreakIntervalSeconds -= 1
                self.timerText = timerSettings.shortBreakIntervalSecondsMinutesSecond
                return
            }
        case .longBreak:
            if self.timerSettings.longBreakIntervalSeconds > 0 {
                self.timerSettings.longBreakIntervalSeconds -= 1
                self.timerText = timerSettings.longBreakIntervalSecondsMinutesSecond
                return
            }
        }
        
        // 設定しているタイマーが0までカウントダウンした場合
        pomodoroState = pomodoroState.next()        
        #warning("タイマー設定を設定画面から取得して設定し直す。現状固定値を設定")
        timerSettings = .init(intervalSeconds: 5, shortBreakIntervalSeconds: 6, longBreakIntervalSeconds: 7)
        switch pomodoroState {
        case .working:
            self.timerText = timerSettings.intervalMinutesSecond
        case .shortBreak:
            self.timerText = timerSettings.shortBreakIntervalSecondsMinutesSecond
        case .longBreak:
            self.timerText = timerSettings.longBreakIntervalSecondsMinutesSecond
        }
    }

    func toggleTimerState() {
        switch timerState {
        case .start:
            timer.invalidate()
            timerState = .stop
        case .stop:
            startTimer()
            timerState = .start
        }
    }
}
