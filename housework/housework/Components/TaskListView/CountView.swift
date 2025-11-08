import SwiftUI

struct CountView: View {
    @Binding var task: HWTask
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var localSeconds: Int = 0
    @State private var localTimer: Timer?
    
    var body: some View {
        VStack(spacing: 40) {
            // タイトルとチェック
            HStack {
                Button(action: {
                    viewModel.toggleTask(task)
                    dismiss()
                }) {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isDone ? .green : .gray)
                        .font(.title2)
                }
                Text(task.title)
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 32)
            
            // カウント表示（時分または分秒）
            Text(formattedTime(localSeconds))
                .font(.system(size: 60, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)
            
            // 開始・ストップボタン
            if task.isRunning {
                Button(action: stopCount) {
                    Label("ストップ", systemImage: "pause.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
            } else {
                Button(action: startCount) {
                    Label("開始", systemImage: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button("閉じる") {
                stopCount()
                dismiss()
            }
            .padding(.bottom, 32)
        }
        .onAppear {
            localSeconds = task.executedSeconds
            if task.isRunning {
                startCount()
            }
        }
        .onDisappear {
            stopCount()
        }
    }
    
    private func startCount() {
        stopCount()
        task.isRunning = true
        viewModel.startGlobalTimer(for: task)
        localTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            localSeconds += 1
            task.executedSeconds = localSeconds
        }
    }
    
    private func stopCount() {
        localTimer?.invalidate()
        localTimer = nil
        task.isRunning = false
        viewModel.stopGlobalTimer()
    }
    
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
