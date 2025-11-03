import SwiftUI

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var newTaskTitle = ""
    @Published var newTaskTime = Date()
    @Published var selectedDuration: Int = 30 // デフォルト30分
    @Published var isAddingTask = false
    
    var incompleteTasks: [Task] {
        tasks.filter { !$0.isDone }
    }
    
    var completedTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    var totalPlannedTime: String {
        let total = tasks.map(\.plannedMinutes).reduce(0, +)
        return TimeFormatter.format(minutes: total)
    }
    
    var totalExecutedTime: String {
        let total = tasks.map(\.executedMinutes).reduce(0, +)
        return TimeFormatter.format(minutes: total)
    }
    
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        let newTask = Task(
            title: newTaskTitle,
            isDone: false,
            plannedMinutes: selectedDuration
        )
        tasks.append(newTask)
        
        newTaskTitle = ""
    }
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }
    
    func startTimer(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].executedMinutes += 5
        }
    }
}
