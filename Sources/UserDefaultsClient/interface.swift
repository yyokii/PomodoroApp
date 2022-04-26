import Foundation

import ComposableArchitecture
import Model

let pomodoroTimerSettingsKey = "pomodoroTimerSettingsKey"

public struct UserDefaultsClient {
    public var boolForKey: (String) -> Bool
    public var dataForKey: (String) -> Data?
    public var doubleForKey: (String) -> Double
    public var integerForKey: (String) -> Int
    public var remove: (String) -> Effect<Never, Never>
    public var setBool: (Bool, String) -> Effect<Never, Never>
    public var setData: (Data?, String) -> Effect<Never, Never>
    public var setDouble: (Double, String) -> Effect<Never, Never>
    public var setInteger: (Int, String) -> Effect<Never, Never>

    public var pomodoroTimerSettings: PomodoroTimerSettings {
        guard let data = self.dataForKey(pomodoroTimerSettingsKey),
              let settings = try? JSONDecoder().decode(PomodoroTimerSettings.self, from: data) else {
                  return .default
        }
        return settings
    }

    public func setPomodoroTimerSettings(_ settings: PomodoroTimerSettings) -> Effect<Never, Never> {
        let data = try? JSONEncoder().encode(settings)
        return setData(data, pomodoroTimerSettingsKey)
    }
}
