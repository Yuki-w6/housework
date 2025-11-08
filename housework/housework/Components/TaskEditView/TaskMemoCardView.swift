import SwiftUI

struct TaskMemoCardView: View {
    @Binding var task: HWTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("メモ")
                .font(.subheadline)
                .foregroundColor(.secondary) // 自動でライト/ダークに馴染む
            
            // TextEditor 本体
            TextEditor(text: $task.memo)
                .font(.body)
                .foregroundColor(Color.appText)
                .scrollContentBackground(.hidden) // 内部の標準背景を消す
                .frame(minHeight: 100)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.appCard) // 入力欄もカード色で
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard) // 外側カード
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}
