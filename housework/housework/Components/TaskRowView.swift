import SwiftUI

struct TaskRowView: View {
    @ObservedObject var viewModel: TaskViewModel
    var task: Task
    var isCompleted: Bool = false
    @State private var showCountView = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // チェックボタン（垂直中央）
            Button(action: {
                viewModel.toggleTask(task)
            }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .font(.title2)
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            
            // 中央コンテンツ（タイトル＋予定時間＋実行時間）
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .strikethrough(task.isDone, color: .gray)
                
                HStack(spacing: 8) {
                    Text("\(task.plannedMinutes)分")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if task.executedSeconds > 0 {
                        Text("実行: \(formattedTime(task.executedSeconds))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // 左揃えを確実にする
            
            // 再生ボタン（完了していないタスクのみ表示、垂直中央）
            if !task.isDone {
                Button(action: {
                    viewModel.startGlobalTimer(for: task)
                    showCountView = true
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showCountView) {
                    if let bindingTask = viewModel.binding(for: task) {
                        CountView(task: bindingTask, viewModel: viewModel)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
    
    // 時間フォーマット
    private func formattedTime(_ totalSeconds: Int) -> String {
        if totalSeconds >= 3600 {
            let h = totalSeconds / 3600
            let m = (totalSeconds % 3600) / 60
            return String(format: "%02d:%02d", h, m)
        } else {
            let m = totalSeconds / 60
            let s = totalSeconds % 60
            return String(format: "%02d:%02d", m, s)
        }
    }
}
