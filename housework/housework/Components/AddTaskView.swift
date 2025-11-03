import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @FocusState private var isFocused: Bool
    
    // 5分単位の選択肢
    private let durationOptions: [Int] = stride(from: 5, through: 120, by: 5).map { $0 }
    
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
                .font(.title3)
            
            TextField("新しいタスクを入力", text: $viewModel.newTaskTitle)
                .textFieldStyle(.plain)
                .focused($isFocused)
                .onSubmit {
                    viewModel.addTask()
                }
                .submitLabel(.done)
            // キーボード上に時間選択バーを表示
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(durationOptions, id: \.self) { minutes in
                                    Button(action: {
                                        viewModel.selectedDuration = minutes
                                    }) {
                                        Text("\(minutes)分")
                                            .font(.caption)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 10)
                                            .background(
                                                viewModel.selectedDuration == minutes
                                                ? Color.blue.opacity(0.25)
                                                : Color(.systemGray5)
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
