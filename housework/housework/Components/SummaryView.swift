import SwiftUI

struct SummaryView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            summaryItem(title: "予定時間", value: viewModel.totalPlannedTime)
            summaryItem(title: "予定タスク数", value: "\(viewModel.incompleteTasks.count)")
            summaryItem(title: "実行済時間", value: viewModel.totalExecutedTime)
            summaryItem(title: "完了済タスク数", value: "\(viewModel.completedTasks.count)")
        }
        .padding(.horizontal)
        Divider().padding(.horizontal)
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
