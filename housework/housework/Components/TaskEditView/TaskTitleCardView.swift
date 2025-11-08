import SwiftUI

struct TaskTitleCardView: View {
    @Binding var task: HWTask
    var onToggleDone: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // タイトル入力
                TextField("タイトルを入力", text: $task.title, axis: .vertical)
                    .textFieldStyle(.plain)
                    .foregroundColor(Color.appText)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1...2)
                    .submitLabel(.done)
                    .strikethrough(task.isDone, color: .gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}
