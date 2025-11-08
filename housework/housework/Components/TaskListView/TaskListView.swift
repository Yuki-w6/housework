// TaskListView.swift
import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    var onSelect: (HWTask) -> Void   // ← 追加
    
    var body: some View {
        let vm = viewModel
        
        VStack(alignment: .leading, spacing: 12) {
            if vm.incompleteTodayTasks.isEmpty {
                Text("今日のタスクはありません")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                Text("タスク")
                    .font(.title2.bold())
                    .foregroundColor(Color.appText)
                    .padding(.horizontal)
                
                ForEach(vm.incompleteTodayTasks) { task in
                    TaskRowView(viewModel: vm, task: task, isCompleted: false)
                        .contentShape(Rectangle())
                        .onTapGesture { onSelect(task) }   // ← 行タップで遷移
                }
            }
            
            if !vm.completedTodayTasks.isEmpty {
                Text("完了済み")
                    .font(.title2.bold())
                    .foregroundColor(Color.appText)
                    .padding(.horizontal)
                
                ForEach(vm.completedTodayTasks) { task in
                    TaskRowView(viewModel: vm, task: task, isCompleted: true)
                }
            }
        }
        .padding(.vertical)
        .background(Color.appBackground.ignoresSafeArea())
    }
}
