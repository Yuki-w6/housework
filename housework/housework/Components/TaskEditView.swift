import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: Task
    @ObservedObject var viewModel: TaskViewModel
    @State private var showDeleteConfirm = false
    
    var body: some View {
        NavigationView {
            Form {
                // ✅ セクション1: チェック＋タイトル
                Section {
                    HStack {
                        Button(action: { task.isDone.toggle() }) {
                            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isDone ? .green : .gray)
                                .font(.title2)
                        }
                        TextField("タイトル", text: $task.title)
                            .font(.headline)
                    }
                }
                
                // ✅ セクション2: 予定時間 / リマインダー / 繰り返し
                Section(header: Text("設定")) {
                    HStack {
                        Text("予定時間")
                        Spacer()
                        Picker(selection: $task.plannedMinutes, label: Text("\(task.plannedMinutes)分")) {
                            ForEach(Array(stride(from: 5, through: 120, by: 5)), id: \.self) { min in
                                Text("\(min)分").tag(min)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Toggle("リマインダー", isOn: $task.isReminderEnabled)
                    
                    Picker("繰り返し", selection: $task.repeatType) {
                        ForEach(RepeatType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                }
                
                // ✅ セクション3: メモ
                Section(header: Text("メモ")) {
                    TextEditor(text: $task.memo)
                        .frame(minHeight: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }
            }
            .navigationTitle("タスク")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("戻る") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("保存") {
                            viewModel.updateTask(task)
                            dismiss()
                        }
                        Button("削除") {
                            showDeleteConfirm = true
                        }
                        .foregroundColor(.red)
                        .confirmationDialog("本当に削除しますか？", isPresented: $showDeleteConfirm) {
                            Button("削除", role: .destructive) {
                                viewModel.deleteTask(task)
                                dismiss()
                            }
                            Button("キャンセル", role: .cancel) { }
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
