public struct PomodoroTimerSettings: Equatable {
    let maxIntervalSeconds = 60 * 60 * 5

    var intervalSeconds: Int
    var shortBreakIntervalSeconds: Int
    var longBreakIntervalSeconds: Int

    static func `default`() -> Self {
        .init(intervalSeconds: 2,
              shortBreakIntervalSeconds: 3,
              longBreakIntervalSeconds: 4)
    }

    var intervalMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: intervalSeconds)
    }

    var shortBreakIntervalSecondsMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: shortBreakIntervalSeconds)
    }

    var longBreakIntervalSecondsMinutesSecond: String {
        return convertSecondsToMinutesSeconds(seconds: longBreakIntervalSeconds)
    }

    func convertSecondsToMinutesSeconds(seconds: Int) -> String {
        let minutesSeconds = ((seconds % 3600) / 60, (seconds % 3600) % 60)
        let minutes = "\(minutesSeconds.0)".zeroPadding(toSize: 3)
        let seconds = "\(minutesSeconds.1)".zeroPadding(toSize: 2)

        return "\(minutes):\(seconds)"
    }
}
