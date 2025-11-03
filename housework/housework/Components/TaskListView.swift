import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.incompleteTasks.isEmpty {
                Text("今日のタスクはありません")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                Text("今日のタスク")
                    .font(.title2.bold())
                    .padding(.horizontal)
                ForEach(viewModel.incompleteTasks) { task in
                    TaskRowView(task: task, toggleTask: viewModel.toggleTask, startTimer: viewModel.startTimer)
                }
            }
            
            Divider().padding(.horizontal)
            
            if !viewModel.completedTasks.isEmpty {
                Text("完了済み")
                    .font(.title2.bold())
                    .padding(.horizontal)
                ForEach(viewModel.completedTasks) { task in
                    TaskRowView(task: task, toggleTask: viewModel.toggleTask, startTimer: viewModel.startTimer, isCompleted: true)
                }
            }
        }
    }
}
