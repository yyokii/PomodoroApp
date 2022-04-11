import APIClient
import ComposableArchitecture

public enum AppDelegateAction: Equatable {
    case didFinishLaunching
}

struct AppDelegateEnvironment {
    var apiClient: ApiClient
}

public struct UserSettings: Codable, Equatable {
    public var isFirstLaunch: Bool

    public init()
}
