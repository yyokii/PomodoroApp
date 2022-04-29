import Foundation

public extension Notification.Name {
    struct UserInfoKey {
        public static let pomodoroMode = "pomodoroMode"
    }

    public static let pomodoroModeChanged = Notification.Name("app.pomodoroModeChanged")
}
