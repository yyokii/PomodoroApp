import FirebaseAuth

struct AppUser {
    let id: String
    let name: String
    let status: UserStatus

    static func getUninitializedData() -> Self {
        .init(id: "",
              name: "",
              status: .uninitialized)
    }
}

enum UserStatus {
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

extension AppUser {
    init(from firebaseUser: User?) {
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

