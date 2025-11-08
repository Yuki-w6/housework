import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @FocusState private var isFocused: Bool
    
    // 5分単位の選択肢
    private let durationOptions: [Int] = stride(from: 5, through: 120, by: 5).map { $0 }
    
    var body: some View {
        HStack(spacing: 8) {
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
                                            .foregroundColor(Color.appText)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 10)
                                            .background(
                                                viewModel.selectedDuration == minutes
                                                ? Color.blue.opacity(0.3)
                                                : Color(UIColor.systemGray5)
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
        .background(Color.appCard) // ✅ カード色（ライト/ダーク対応）
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    Group {
        VStack {
            AddTaskView(viewModel: TaskViewModel())
            Spacer()
        }
        .background(Color.appBackground)
    }
}
