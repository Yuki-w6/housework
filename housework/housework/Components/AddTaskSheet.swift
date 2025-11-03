//import SwiftUI
//
//struct AddTaskSheet: View {
//    @Binding var isPresented: Bool
//    @Binding var newTaskTitle: String
//    @State private var selectedCategory: String = "掃除"
//    @State private var selectedRepeatType: RepeatType = .none
//    @State private var isReminderEnabled: Bool = false
//    
//    var onAdd: (_ repeatType: RepeatType, _ reminderEnabled: Bool) -> Void
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Capsule()
//                .fill(Color.gray.opacity(0.3))
//                .frame(width: 40, height: 5)
//                .padding(.top, 8)
//            
//            Text("新しい家事を追加")
//                .font(.headline)
//                .padding(.bottom, 8)
//            
//            // タイトル入力欄
//            TextField("追加する家事を入力してください", text: $newTaskTitle)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(.horizontal)
//            
//            // 繰り返し設定
//            HStack {
//                Text("繰り返し")
//                Spacer()
//                Picker("繰り返し", selection: $selectedRepeatType) {
//                    ForEach(RepeatType.allCases, id: \.self) { type in
//                        Text(type.rawValue).tag(type)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
//            }
//            .padding(.horizontal)
//            
//            // リマインダー設定
//            Toggle(isOn: $isReminderEnabled) {
//                Text("リマインダーを設定する")
//            }
//            .padding(.horizontal)
//            
//            Button(action: {
//                onAdd(selectedRepeatType, isReminderEnabled)
//                isPresented = false
//            }) {
//                Text("追加する")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
//            
//            Spacer()
//        }
//        .padding(.top)
//        .presentationDetents([.fraction(0.55)])
//    }
//}
