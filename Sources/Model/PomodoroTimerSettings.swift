import SwiftHelper

public struct PomodoroTimerSettings: Codable, Equatable {
    // 各ポモドーロの時間設定を「seconds」単位で保持
    public var intervalSeconds: Int
    public var shortBreakIntervalSeconds: Int
    public var longBreakIntervalSeconds: Int
    
    public static var `default`: Self = .init(intervalSeconds: 25 * 60,
                                              shortBreakIntervalSeconds: 1 * 60,
                                              longBreakIntervalSeconds: 15 * 60)

    public var intervalMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: intervalSeconds)
    }

    public var shortBreakIntervalMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: shortBreakIntervalSeconds)
    }

    public var longBreakIntervalMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: longBreakIntervalSeconds)
    }

    public init(
        intervalSeconds: Int,
        shortBreakIntervalSeconds: Int,
        longBreakIntervalSeconds: Int
    ) {
        self.intervalSeconds = intervalSeconds
        self.shortBreakIntervalSeconds = shortBreakIntervalSeconds
        self.longBreakIntervalSeconds = longBreakIntervalSeconds
    }

    private func convertSecondsToMinutesSeconds(seconds: Int) -> String {
        let minutesSeconds = ((seconds % 3600) / 60, (seconds % 3600) % 60)
        let minutes = "\(minutesSeconds.0)".zeroPadding(toSize: 3)
        let seconds = "\(minutesSeconds.1)".zeroPadding(toSize: 2)

        return "\(minutes):\(seconds)"
    }

}
