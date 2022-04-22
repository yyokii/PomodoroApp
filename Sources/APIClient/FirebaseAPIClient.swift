import Combine

import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import Model

public struct FirebaseAPIClient {
    // Auth
    public var checkUserStatus: () -> Effect<AppUser, Never>
    public var signInAnonymously: () -> Effect<None, APIError>
    public var signUp: (_ email: String, _ password: String) -> Effect<None, APIError>

    // Pomodoro History
    public var savePomodoroHistory: (_ history: PomodoroTimerHistory) -> Effect<None, Never>

    public init(
        checkUserStatus: @escaping () -> Effect<AppUser, Never>,
        signInAnonymously: @escaping () -> Effect<None, APIError>,
        signUp: @escaping (_ email: String, _ password: String) -> Effect<None, APIError>,
        savePomodoroHistory: @escaping (_ history: PomodoroTimerHistory) -> Effect<None, Never>) {
            self.checkUserStatus = checkUserStatus
            self.signInAnonymously = signInAnonymously
            self.signUp = signUp
            self.savePomodoroHistory = savePomodoroHistory
        }
}

public extension FirebaseAPIClient {
    static var appUser: AppUser = .init(id: "", name: "", status: .uninitialized)
    static let db: Firestore = Firestore.firestore()

    static let live = Self(
        checkUserStatus: {
            let firebaseUser = Auth.auth().currentUser
            let appUser: AppUser = .init(from: firebaseUser)
            FirebaseAPIClient.appUser = appUser
            return Just(appUser)
                .eraseToEffect()
        },
        signInAnonymously: {
            Auth.auth().signInAnonymously()
                .map { result in
                    let appUser: AppUser = .init(from: result.user)
                    FirebaseAPIClient.appUser = appUser
                    return None()
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
        },
        savePomodoroHistory: { history in
            let _ = try! db.collection(FirestorePathComponent.user.rawValue)
                .document(appUser.id)
                .collection(FirestorePathComponent.pomodoroHistory.rawValue)
                .addDocument(from: history)
            return .none
        }
    )
}

extension FirebaseAPIClient {
    enum FirestorePathComponent: String {
        case pomodoroHistory = "pomodoro_timer_history"
        case user = "user"
    }
}
