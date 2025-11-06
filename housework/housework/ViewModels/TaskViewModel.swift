import SwiftUI
import Combine

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet { saveTasks() }
    }
    @Published var newTaskTitle = ""
    @Published var selectedDuration: Int = 30
    @Published var currentTaskID: UUID? = nil
    
    private var timer: Timer?
    private let saveKey = "savedTasks"
    
    init() {
        loadTasks()
    }
    
    // MARK: - 追加・更新・削除
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = Task(title: newTaskTitle, plannedMinutes: selectedDuration)
        tasks.append(newTask)
        newTaskTitle = ""
    }
    
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
    
    func deleteTask(_ task: Task) {
        stopGlobalTimer()
        tasks.removeAll { $0.id == task.id }
    }
    
    // MARK: - 状態フィルタ
    var incompleteTasks: [Task] { tasks.filter { !$0.isDone } }
    var completedTasks: [Task] { tasks.filter { $0.isDone } }
    
    func toggleTask(_ task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
        
        if tasks[index].isDone {
            // 完了したら実行時間リセット
            tasks[index].executedSeconds = 0
            tasks[index].isRunning = false
            if currentTaskID == task.id {
                stopGlobalTimer()
            }
        } else {
            // 未完了に戻したら停止状態で再開可
            tasks[index].isRunning = false
        }
    }
    
    // MARK: - タスク切り替え制御
    func startGlobalTimer(for task: Task) {
        if let runningID = currentTaskID,
           let oldIndex = tasks.firstIndex(where: { $0.id == runningID }),
           runningID != task.id {
            // 前のタスクを完了状態にせず、停止状態へ
            tasks[oldIndex].isRunning = false
        }
        
        guard let index = tasks.firstIndex(of: task) else { return }
        currentTaskID = task.id
        tasks[index].isRunning = true
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self, let runningID = self.currentTaskID,
                      let idx = self.tasks.firstIndex(where: { $0.id == runningID }) else { return }
                self.tasks[idx].executedSeconds += 1
            }
        }
    }
    
    func stopGlobalTimer() {
        timer?.invalidate()
        timer = nil
        
        // 実行中タスクを停止状態にする
        if let runningID = currentTaskID,
           let idx = tasks.firstIndex(where: { $0.id == runningID }) {
            tasks[idx].isRunning = false
        }
        currentTaskID = nil
    }
    
    // MARK: - Binding 取得
    func binding(for task: Task) -> Binding<Task>? {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return nil }
        return Binding(
            get: { self.tasks[index] },
            set: { self.tasks[index] = $0 }
        )
    }
    
    func completeTask(_ task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone = true
        tasks[index].executedSeconds = 0
        stopGlobalTimer()
    }
    
    // MARK: - 表示用集計
    var totalPlannedTime: String {
        let totalMinutes = tasks.map(\.plannedMinutes).reduce(0, +)
        return formatMinutes(totalMinutes)
    }
    var totalExecutedTime: String {
        let totalSeconds = tasks.map(\.executedSeconds).reduce(0, +)
        let totalMinutes = totalSeconds / 60
        return formatMinutes(totalMinutes)
    }
    
    private func formatMinutes(_ minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }
    
    // MARK: - 永続化
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("保存失敗: \(error)")
        }
    }
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("読み込み失敗: \(error)")
        }
    }
}
