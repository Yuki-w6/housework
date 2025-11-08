import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        let vm = viewModel
        
        VStack(alignment: .leading, spacing: 16) {
            // カード全体（背景含む）
            HStack(spacing: 12) {
                summaryItem(title: "予定時間", value: vm.totalPlannedTime)
                summaryItem(title: "予定タスク数", value: "\(vm.incompleteTasks.count)")
                summaryItem(title: "実行時間", value: vm.totalExecutedTime)
                summaryItem(title: "完了タスク数", value: "\(vm.completedTasks.count)")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appCard) // ✅ カード色（ダークモード対応）
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .background(Color.appBackground.ignoresSafeArea()) // ✅ 背景色
    }
    
    private func summaryItem(title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color.appText) // ✅ テキストカラー（モード対応）
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#Preview {
    Group {
        SummaryView(viewModel: TaskViewModel())
    }
}
