import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
    var plannedMinutes: Int = 0
    var executedMinutes: Int = 0
}
