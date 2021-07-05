import Foundation


extension Date {
    func toYearMonthDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringValue = dateFormatter.string(from: self)
        return stringValue
    }
}
