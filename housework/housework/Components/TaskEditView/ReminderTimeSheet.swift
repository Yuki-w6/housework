import SwiftUI

struct ReminderTimeSheet: View {
    @Binding var selectedDate: Date
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("リマインダー時刻を設定")
                .font(.headline)
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            HStack(spacing: 40) {
                Button("キャンセル", action: onCancel)
                    .foregroundColor(.gray)
                Button("OK", action: onConfirm)
                    .bold()
            }
            Spacer()
        }
        .padding()
    }
}
