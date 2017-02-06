import Foundation
import Argo

extension Date {
    func toDateTime() -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let second = calendar.component(.second, from: self)
        return "\(year)-\(month)-\(day) \(hour):\(minute):\(second)"
    }
}

extension Date: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch json {
        case let .string(s):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            if let date = dateFormatter.date(from: s) {
                return pure(date)
            } else {
                return .customError("got \(s), but expected ISO8601")
            }
        default:
            return .typeMismatch(expected: "String", actual: json)
        }
    }
}

