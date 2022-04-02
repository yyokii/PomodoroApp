import Foundation.NSDate

extension DateFormatter {
    public enum Template: String {
        case day = "d"
        case weekDay = "EEE"
    }

    public func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0にしています
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}
