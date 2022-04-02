import Combine
import Foundation.NSDate

import SwiftHelper

struct DateItemViewData: Identifiable {
    let id = UUID()

    /// Original Date
    let date: Date

    let dayOfWeek: String
    let day: String
    let isToday: Bool

    init(with date: Date) {
        self.date = date
        dayOfWeek = date.toString(format: .weekDay)
        day = date.toString(format: .day)

        let now = Date()
        let nowDateComponent = Calendar.appCalendar.dateComponents([.year, .month, .day], from: now)
        let targetDateComponent = Calendar.appCalendar.dateComponents([.year, .month, .day], from: date)
        isToday = nowDateComponent == targetDateComponent
    }
}

final class DataViewModel: ObservableObject {
    @Published var dateItems: [DateItemViewData] = []

    init() {
        let now = Date()
        print(now)
        let start = Date().startOfWeek
        print(start)
        dateItems = Date().daysOfWeek
            .map{
                .init(with: $0)
            }
    }
}
