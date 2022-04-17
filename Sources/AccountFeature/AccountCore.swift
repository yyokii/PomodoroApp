import APIClient
import ComposableArchitecture
import SwiftHelper

public struct AccountState: Equatable {
    public init() {}
}

public enum AccountAction: Equatable {}

public struct AccountEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(apiClient: FirebaseAPIClient,
                mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.apiClient = apiClient
        self.mainQueue = mainQueue
    }
}

public let accountReducer = Reducer<AccountState, AccountAction, AccountEnvironment> { state, action, environment in
        .none
}
