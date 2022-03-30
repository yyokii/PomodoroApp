import Combine
import Foundation.NSTimer

extension String {
    func zeroPadding(toSize: Int) -> String {
        var padded = self
        for _ in 0..<(toSize - count) {
            padded = "0" + padded
        }
        return padded
    }
}

final class TimerViewModel: ObservableObject {

    struct TimerSettings {
        let maxIntervalSeconds = 60 * 60 * 5

        var intervalSeconds: Int
        var breakIntervalSeconds: Int
        var longIntervalSeconds: Int

        static func `default`() -> Self {
            .init(intervalSeconds: 2,
                  breakIntervalSeconds: 5,
                  longIntervalSeconds: 10)
        }

        var intervalMinutesSecond: String {
            return convertSecondsToMinutesSeconds(seconds: intervalSeconds)
        }

//        var breakIntervalSecondsMinutesSecond: (Int, Int) {
//            return convertSecondsToMinutesSeconds(seconds: breakIntervalSeconds)
//        }

        func convertSecondsToMinutesSeconds(seconds: Int) -> String {
            let minutesSeconds = ((seconds % 3600) / 60, (seconds % 3600) % 60)
            let minutes = "\(minutesSeconds.0)".zeroPadding(toSize: 3)
            let seconds = "\(minutesSeconds.1)".zeroPadding(toSize: 2)

            return "\(minutes):\(seconds)"
        }
    }

    // 表示用のタイマー設定
    @Published var currentTimerSettings: TimerSettings = .default()
    // 現在のタイマー設定（修正した場合はここに反映され、次回のセッションより表示に反映される）
    var timerSettings: TimerSettings = .init(intervalSeconds: 50, breakIntervalSeconds: 10, longIntervalSeconds: 10)

    private var cancellables = Set<AnyCancellable>()

    init() {
        // RunLoop.Mode: https://developer.apple.com/documentation/foundation/runloop/mode
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.currentTimerSettings.intervalSeconds > 0 {
                    self.currentTimerSettings.intervalSeconds -= 1
                } else {
                    self.currentTimerSettings = self.timerSettings
                }
            }
            .store(in: &cancellables)
    }
}
