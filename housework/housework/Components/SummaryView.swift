import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        let vm = viewModel  // 👈 明示的にローカル変数化（コンパイラバグ回避）
        
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                summaryItem(title: "予定時間", value: vm.totalPlannedTime)
                summaryItem(title: "予定タスク数", value: "\(vm.incompleteTasks.count)")
                summaryItem(title: "実行済時間", value: vm.totalExecutedTime)
                summaryItem(title: "完了済タスク数", value: "\(vm.completedTasks.count)")
            }
            .padding(.horizontal)
            Divider().padding(.horizontal)
        }
    }
    
    private func summaryItem(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
        }
    }
}
