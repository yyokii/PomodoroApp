import Combine

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore

public struct Failure: Error, Equatable {
    let error: String
}

public struct None: Equatable {
    public init() {}
}

public struct FirebaseAPIClient {
    public var signUp: (_ email: String, _ password: String) -> Effect<None, APIError>
    public var signInAnonymously: () -> Effect<None, APIError>

    public init(
        signInAnonymously: @escaping () -> Effect<None, APIError>,
        signUp: @escaping (_ email: String, _ password: String) -> Effect<None, APIError>) {
            self.signInAnonymously = signInAnonymously
            self.signUp = signUp
        }
}

public extension FirebaseAPIClient {

    static let live = Self(
        signInAnonymously: {
            Auth.auth().signInAnonymously()
                .map { _ in
                    None()
                }
                .mapError { error in
                    APIError.init(error: error)
                }
                .eraseToEffect()
        },
        signUp: { _, _ in
            Just(None())
                .mapError({ error in
                    APIError.init(error: error)
                })
                .eraseToEffect()
        }
    )
}
