import SwiftUI

struct DurationSettingSheet: View {
    @Binding var selectedMinutes: Int
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    let durations = Array(stride(from: 5, through: 120, by: 5))
    
    var body: some View {
        VStack(spacing: 16) {
            Text("予定時間を設定")
                .font(.headline)
            Picker("", selection: $selectedMinutes) {
                ForEach(durations, id: \.self) { min in
                    Text("\(min)分").tag(min)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 120)
            
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
