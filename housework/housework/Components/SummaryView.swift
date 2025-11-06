import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        let vm = viewModel
        
        // 背景付きカードレイアウト
        VStack(alignment: .leading, spacing: 16) {
            
            // 各項目をカードっぽく並べる
            HStack(spacing: 12) {
                summaryItem(title: "予定時間", value: vm.totalPlannedTime)
                summaryItem(title: "予定タスク数", value: "\(vm.incompleteTasks.count)")
                summaryItem(title: "実行時間", value: vm.totalExecutedTime)
                summaryItem(title: "完了タスク数", value: "\(vm.completedTasks.count)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
    
    private func summaryItem(title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded)) // フォントを大きく
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity) // 均等幅配置
        .padding(.vertical, 8)
    }
}
