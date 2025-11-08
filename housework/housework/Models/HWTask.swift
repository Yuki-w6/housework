import Foundation

struct HWTask: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var isDone: Bool
    var plannedMinutes: Int
    var executedSeconds: Int = 0
    var isRunning: Bool = false
    var reminderDate: Date? = nil
    var repeatDays: [String] = []
    var isReminderEnabled: Bool = false
    var memo: String = ""
    var completedAt: Date? = nil 
    
    init(
        id: UUID = UUID(),
        title: String,
        isDone: Bool = false,
        plannedMinutes: Int
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.plannedMinutes = plannedMinutes
    }
}

enum RepeatType: String, Codable, CaseIterable {
    case none = "なし"
    case daily = "毎日"
    case weekly = "毎週"
    case monthly = "毎月"
}
