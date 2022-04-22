import FirebaseFirestore
import FirebaseFirestoreSwift

public struct PomodoroTimerHistory: Codable, Equatable {
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
    var startTime: Timestamp
    var endTime: Timestamp
    var category: [String]
    var pomodoroState: String

    public init (
        id: String? = nil,
        createdTime: Timestamp? = nil,
        startTime: Timestamp,
        endTime: Timestamp,
        category: [String],
        pomodoroState: String
    ) {
        self.id = id
        self.createdTime = createdTime
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
        self.pomodoroState = pomodoroState
    }
}
