public struct PomodoroTimerSettings: Codable {
    public var intervalTime: Int
    public var shortBreakTime: Int
    public var longBreakTime: Int
    
    public static var `default`: Self = .init(intervalTime: 25,
                                              shortBreakTime: 1,
                                              longBreakTime: 15)
    public init(
        intervalTime: Int,
        shortBreakTime: Int,
        longBreakTime: Int
    ) {
        self.intervalTime = intervalTime
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
    }
}
