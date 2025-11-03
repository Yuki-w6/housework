import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var isSheetPresented = false
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 今日のタスクタイトル
                    Text("今日のタスク")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                    
                    // 未完了タスク
                    if incompleteTasks.isEmpty {
                        Text("未完了のタスクはありません")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(incompleteTasks) { task in
                            TaskCard(task: task) {
                                toggleTask(task)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 完了タスク
                    Text("完了したタスク")
                        .font(.title2.bold())
                        .padding(.horizontal)
                    
                    if completedTasks.isEmpty {
                        Text("まだ完了したタスクはありません")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(completedTasks) { task in
                            TaskCard(task: task, isCompleted: true) {
                                toggleTask(task)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isSheetPresented = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                AddTaskSheet(
                    isPresented: $isSheetPresented,
                    newTaskTitle: $newTaskTitle
                ) { repeatType, isReminderEnabled in
                    addTask(repeatType: repeatType, isReminderEnabled: isReminderEnabled)
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
    
    // 未完了タスクと完了タスクを分ける
    private var incompleteTasks: [Task] {
        tasks.filter { !$0.isDone }
    }
    
    private var completedTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    private func addTask(repeatType: RepeatType, isReminderEnabled: Bool) {
        guard !newTaskTitle.isEmpty else { return }
        
        let newTask = Task(
            title: newTaskTitle,
            isDone: false,
            repeatType: repeatType,
            isReminderEnabled: isReminderEnabled
        )
        tasks.append(newTask)
        
        if isReminderEnabled {
            NotificationManager.shared.scheduleNotification(for: newTask)
        }
        
        newTaskTitle = ""
    }
    
    private func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }
}

// MARK: - Task Card View
struct TaskCard: View {
    let task: Task
    var isCompleted: Bool = false
    var toggleAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: toggleAction) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isDone ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            Text(task.title)
                .font(.headline)
                .strikethrough(task.isDone, color: .gray)
                .foregroundColor(task.isDone ? .gray : .primary)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
