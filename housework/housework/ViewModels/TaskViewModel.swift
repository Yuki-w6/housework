import SwiftUI
import Combine

final class TaskViewModel: ObservableObject {
    @Published var tasks: [HWTask] = [] {
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
    
    // 追加・更新・削除
    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = HWTask(
            title: newTaskTitle,
            isDone: false,
            plannedMinutes: selectedDuration
        )
        tasks.append(newTask)
        newTaskTitle = ""
        saveTasks()
        
        // 通知登録（リマインダーがある場合）
        if newTask.reminderDate != nil {
            NotificationManager.shared.scheduleNotification(for: newTask)
        }
    }
    
    func updateTask(_ updatedTask: HWTask) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            saveTasks()
            
            NotificationManager.shared.cancelNotification(for: updatedTask)
            if updatedTask.reminderDate != nil {
                NotificationManager.shared.scheduleNotification(for: updatedTask)
            }
        }
    }
    
    func deleteTask(_ task: HWTask) {
        stopGlobalTimer()
        NotificationManager.shared.cancelNotification(for: task)
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    // 状態フィルタ
    var incompleteTasks: [HWTask] { tasks.filter { !$0.isDone } }
    var completedTasks: [HWTask] { tasks.filter { $0.isDone } }
    
    func toggleTask(_ task: HWTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
        
        if tasks[index].isDone {
            // 完了したら実行時間リセット
            tasks[index].executedSeconds = 0
            tasks[index].isRunning = false
            tasks[index].completedAt = Date()
            if currentTaskID == task.id {
                stopGlobalTimer()
            }
        } else {
            tasks[index].completedAt = nil
            tasks[index].isRunning = false
        }
    }
    
    // MARK: - タスク切り替え制御
    func startGlobalTimer(for task: HWTask) {
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
    func binding(for task: HWTask) -> Binding<HWTask>? {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return nil }
        return Binding(
            get: { self.tasks[index] },
            set: { self.tasks[index] = $0 }
        )
    }
    
    func completeTask(_ task: HWTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone = true
        tasks[index].executedSeconds = 0
        stopGlobalTimer()
    }
    
    // MARK: - 表示用集計
    var totalPlannedTime: String {
        let totalMinutes = (incompleteTodayTasks + completedTodayTasks).map(\.plannedMinutes).reduce(0, +)
        return formatMinutes(totalMinutes)
    }
    var totalExecutedTime: String {
        let totalSeconds = (incompleteTodayTasks + completedTodayTasks).map(\.executedSeconds).reduce(0, +)
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
            tasks = try JSONDecoder().decode([HWTask].self, from: data)
        } catch {
            print("読み込み失敗: \(error)")
        }
    }
    
    private var todayWeekdaySymbol: String {
        // 「日,月,火,水,木,金,土」のどれかに合わせる
        let map = ["日","月","火","水","木","金","土"]
        let w = Calendar.current.component(.weekday, from: Date()) // 1=Sun ... 7=Sat
        return map[(w - 1) % 7]
    }
    
    private func isRepeatActiveToday(_ task: HWTask) -> Bool {
        // 繰り返し設定があり、今日の曜日が含まれるか
        guard !task.repeatDays.isEmpty else { return false }
        return task.repeatDays.contains(todayWeekdaySymbol)
    }
    
    private func isCompletedToday(_ task: HWTask) -> Bool {
        guard let completed = task.completedAt else { return false }
        return Calendar.current.isDateInToday(completed)
    }
    
    private func isTargetForToday(_ task: HWTask) -> Bool {
        // ① 繰り返し：今日の曜日に該当する → 今日の対象
        // ② 単発：未完了のものだけが対象（完了済みは翌日以降は出さない）
        if isRepeatActiveToday(task) { return true }
        return !task.isDone
    }
    
    // ✅ 今日の未完了
    var incompleteTodayTasks: [HWTask] {
        tasks.filter { task in
            if isRepeatActiveToday(task) {
                // 繰り返し：今日分が未完なら表示
                return !isCompletedToday(task)
            } else {
                // 単発：未完のものだけ表示（完了したら翌日以降は出さない）
                return !task.isDone
            }
        }
    }
    
    // ✅ 今日の完了（繰り返しは “今日分を完了したもの” だけ）
    var completedTodayTasks: [HWTask] {
        // ✅ 今日完了したタスクは表示（繰り返し/単発どちらも）
        tasks.filter { isCompletedToday($0) }
    }

}
