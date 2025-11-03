import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
    var repeatType: RepeatType = .none
    var isReminderEnabled: Bool = false
}

enum RepeatType: String, Codable, CaseIterable {
    case none = "なし"
    case daily = "毎日"
    case weekly = "毎週"
    case monthly = "毎月"
}
