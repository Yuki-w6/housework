// TaskRowView.swift
import SwiftUI

struct TaskRowView: View {
    @ObservedObject var viewModel: TaskViewModel
    var task: HWTask
    var isCompleted: Bool = false
    @State private var showCountView = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // チェック
            Button {
                viewModel.toggleTask(task)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .font(.title2)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            
            // タイトル & 時間
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(task.isDone ? .gray : Color.appText)
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 再生（未完了のみ）
            if !task.isDone {
                Button {
                    viewModel.startGlobalTimer(for: task)
                    showCountView = true
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showCountView) {
                    if let bindingTask = viewModel.binding(for: task) {
                        CountView(task: bindingTask, viewModel: viewModel)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCard)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
    
    private func formattedTime(_ s: Int) -> String {
        if s >= 3600 {
            String(format: "%02d:%02d", s/3600, (s%3600)/60)
        } else {
            String(format: "%02d:%02d", s/60, s%60)
        }
    }
}
