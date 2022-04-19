import FirebaseAuth

public struct AppUser: Equatable {
    public let id: String
    public let name: String
    public let status: UserStatus

    public init(
        id: String,
        name: String,
        status: UserStatus
    ) {
        self.id = id
        self.name = name
        self.status = status
    }

    static func getUninitializedData() -> Self {
        .init(id: "",
              name: "",
              status: .uninitialized)
    }
}

extension AppUser {
    public enum UserStatus {
        // ユーザー情報が未作成
        case uninitialized
        // ログイン状態
        case authenticated
        // 匿名ログイン状態
        case authenticatedAnonymously

        var statusName: String {
            switch self {
            case.uninitialized:
                return "未ログイン"
            case.authenticated:
                return "ログイン済み"
            case .authenticatedAnonymously:
                return "ゲスト"
            }
        }
    }

    public init(from firebaseUser: User?) {
        if  firebaseUser == nil {
            // 未認証
            id = ""
            name = ""
            status = .uninitialized
        } else if firebaseUser!.isAnonymous {
            // 匿名ログイン
            id = firebaseUser!.uid
            name = ""
            status = .authenticatedAnonymously
        } else {
            // ログイン済
            id = firebaseUser!.uid
            name = firebaseUser?.displayName ?? ""
            status = .authenticated
        }
    }
}

