import Foundation.NSDate

extension Date {
    public var startOfWeek: Date {
        /*
         For a given date, the weekOfYear property indicates which week the date falls in, and yearForWeekOfYear provides the corresponding week-numbering year.
         https://developer.apple.com/documentation/foundation/nsdatecomponents/1413809-yearforweekofyear
         */
        return Calendar.appCalendar.date(from: Calendar.appCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }

    public var daysOfWeek: [Date] {
        let startOfWeek = self.startOfWeek
        return (0...6).compactMap{ Calendar.appCalendar.date(byAdding: .day, value: $0, to: startOfWeek)}
    }
}
