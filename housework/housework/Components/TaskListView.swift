import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        let vm = viewModel // 👈 同様にローカル変数でバグ回避
        
        VStack(alignment: .leading, spacing: 8) {
            if vm.incompleteTasks.isEmpty {
                Text("今日のタスクはありません")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                Text("タスク")
                    .font(.title2.bold())
                    .padding(.horizontal)
                ForEach(vm.incompleteTasks) { task in
                    TaskRowView(viewModel: vm, task: task, isCompleted: false)
                }
            }
            
            Divider().padding(.horizontal)
            
            if !vm.completedTasks.isEmpty {
                Text("完了済み")
                    .font(.title2.bold())
                    .padding(.horizontal)
                ForEach(vm.completedTasks) { task in
                    TaskRowView(viewModel: vm, task: task, isCompleted: true)
                }
            }
        }
    }
}
