import Foundation.NSDate

extension Calendar {
    public static var appCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Etc/UTC")!
        calendar.locale   = .current
        return calendar
    }
}
