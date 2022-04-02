import Combine
import Foundation.NSDate

extension Calendar {
    public static var appCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Etc/UTC")!
        calendar.locale   = .current
        return calendar
    }
}

extension Date {
    /// DateからStringを生成
    func toString(format: DateFormatter.Template, timeZone: TimeZone = TimeZone.init(identifier: "GMT")!) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }

    var startOfWeek: Date {
        /*
         For a given date, the weekOfYear property indicates which week the date falls in, and yearForWeekOfYear provides the corresponding week-numbering year.
         https://developer.apple.com/documentation/foundation/nsdatecomponents/1413809-yearforweekofyear
         */
        return Calendar.appCalendar.date(from: Calendar.appCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    var daysOfWeek: [Date] {
        let startOfWeek = self.startOfWeek
        return (0...6).compactMap{ Calendar.appCalendar.date(byAdding: .day, value: $0, to: startOfWeek)}
    }
}

extension DateFormatter {
    // テンプレートの定義
    public enum Template: String {
        case day = "d"
        case weekDay = "EEE" // 曜日
    }

    public func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}

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
