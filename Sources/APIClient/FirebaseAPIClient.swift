import Combine

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import Model

public struct FirebaseAPIClient {
    public var checkUserStatus: () -> Effect<AppUser, Never>
    public var signUp: (_ email: String, _ password: String) -> Effect<None, APIError>
    public var signInAnonymously: () -> Effect<None, APIError>

    public init(
        checkUserStatus: @escaping () -> Effect<AppUser, Never>,
        signInAnonymously: @escaping () -> Effect<None, APIError>,
        signUp: @escaping (_ email: String, _ password: String) -> Effect<None, APIError>) {
            self.checkUserStatus = checkUserStatus
            self.signInAnonymously = signInAnonymously
            self.signUp = signUp
        }
}

public extension FirebaseAPIClient {
    static let live = Self(
        checkUserStatus: {
            let firebaseUser = Auth.auth().currentUser
            let appUser: AppUser = .init(from: firebaseUser)
            return Just(appUser)
                .eraseToEffect()
        },
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
