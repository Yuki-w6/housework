import SwiftUI
import Combine

final class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks() // ✅ 変更があれば自動保存
        }
    }
    @Published var newTaskTitle = ""
    @Published var selectedDuration: Int = 30
    
    private var timers: [UUID: AnyCancellable] = [:]
    private let saveKey = "savedTasks" // UserDefaultsのキー名
    
    init() {
        loadTasks()
    }
    
    var incompleteTasks: [Task] {
        tasks.filter { !$0.isDone }
    }
    
    var completedTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    // MARK: - 追加
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
    
    // MARK: - 更新
    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }
    
    // MARK: - 削除
    func deleteTask(_ task: Task) {
        stopTimer(for: task)
        tasks.removeAll { $0.id == task.id }
    }
    
    // MARK: - タスク状態操作
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(of: task) {
            tasks[index].isDone.toggle()
            stopTimer(for: tasks[index])
        }
    }
    
    func binding(for task: Task) -> Binding<Task>? {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return nil }
        return Binding(
            get: { self.tasks[index] },
            set: { self.tasks[index] = $0 }
        )
    }
    
    // MARK: - タイマー制御
    func startOrStopTimer(_ task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        if tasks[index].isRunning {
            stopTimer(for: tasks[index])
        } else {
            startTimer(for: tasks[index])
        }
    }
    
    private func startTimer(for task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isRunning = true
        
        timers[task.id] = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if let idx = self.tasks.firstIndex(of: task), self.tasks[idx].isRunning {
                    self.tasks[idx].executedSeconds += 1
                }
            }
    }
    
    private func stopTimer(for task: Task) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isRunning = false
        timers[task.id]?.cancel()
        timers[task.id] = nil
    }
    
    // MARK: - 合計時間
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
        let hours = minutes / 60
        let mins = minutes % 60
        return String(format: "%02d:%02d", hours, mins)
    }
    
    // MARK: - 永続化処理
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("❌ タスクの保存に失敗: \(error)")
        }
    }
    
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("❌ タスクの読み込みに失敗: \(error)")
        }
    }
}
