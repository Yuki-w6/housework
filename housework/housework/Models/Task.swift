import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
    var plannedMinutes: Int = 0
    var executedSeconds: Int = 0
    var isRunning: Bool = false
    var isReminderEnabled: Bool = false
    var repeatType: RepeatType = .none
    var memo: String = ""
}

enum RepeatType: String, Codable, CaseIterable {
    case none = "なし"
    case daily = "毎日"
    case weekly = "毎週"
    case monthly = "毎月"
}
