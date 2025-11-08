import SwiftUI

struct TaskSettingCardView: View {
    @Binding var task: HWTask
    @Binding var showDurationSheet: Bool
    @Binding var showReminderSheet: Bool
    @Binding var showRepeatSheet: Bool
    @Binding var tempPlannedMinutes: Int
    @Binding var tempReminderTime: Date
    
    var body: some View {
        VStack(spacing: 16) {
            settingRow(
                icon: "timer",
                title: "予定時間",
                value: "\(task.plannedMinutes)分"
            ) {
                tempPlannedMinutes = task.plannedMinutes
                showDurationSheet = true
            }
            
            settingRow(
                icon: "bell",
                title: "リマインダー",
                value: task.reminderDate?.formatted(date: .omitted, time: .shortened) ?? "なし"
            ) {
                tempReminderTime = task.reminderDate ?? Date()
                showReminderSheet = true
            }
            
            settingRow(
                icon: "arrow.triangle.2.circlepath",
                title: "繰り返し",
                value: task.repeatDays.isEmpty ? "なし" : task.repeatDays.joined(separator: ", ")
            ) {
                showRepeatSheet = true
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appCard) // ✅ ライト/ダーク対応カード色
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    private func settingRow(icon: String, title: String, value: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(.secondary) // ✅ モード適応の補助色
                
                Text(title)
                    .foregroundColor(Color.appText)
                
                Spacer()
                
                Text(value)
                    .foregroundColor(value == "なし" ? .secondary : .blue) // ✅ なし→控えめ、あり→アクセント
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain) // ✅ 押下時の色反転を抑制しつつ行全体をタップ可能に
    }
}
