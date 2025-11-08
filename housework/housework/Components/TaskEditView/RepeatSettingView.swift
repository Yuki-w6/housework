import SwiftUI

// 繰り返し設定シート
struct RepeatSettingView: View {
    @Binding var task: HWTask
    let weekdays = ["月", "火", "水", "木", "金", "土", "日"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("繰り返し設定")
                .font(.headline)
            HStack(spacing: 12) {
                ForEach(weekdays, id: \.self) { day in
                    Button(action: {
                        if task.repeatDays.contains(day) {
                            task.repeatDays.removeAll { $0 == day }
                        } else {
                            task.repeatDays.append(day)
                        }
                    }) {
                        Text(day)
                            .frame(width: 40, height: 40)
                            .background(task.repeatDays.contains(day) ? Color.blue : Color(.systemGray5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}
