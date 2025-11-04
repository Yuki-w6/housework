import SwiftUI

struct TaskRowView: View {
    @ObservedObject var viewModel: TaskViewModel
    var task: Task
    var isCompleted: Bool = false
    @State private var isEditing = false
    
    var body: some View {
        Button(action: { isEditing = true }) {
            HStack(alignment: .top, spacing: 12) {
                Button(action: { viewModel.toggleTask(task) }) {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isDone ? .green : .gray)
                        .font(.title2)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundColor(task.isDone ? .gray : .primary)
                        .strikethrough(task.isDone, color: .gray)
                    
                    HStack(spacing: 6) {
                        Text("\(task.plannedMinutes)分")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if task.executedSeconds > 0 || task.isRunning {
                            Text("実行: \(task.executedSeconds / 60):\(String(format: "%02d", task.executedSeconds % 60))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
                
                if !isCompleted {
                    Button(action: { viewModel.startOrStopTimer(task) }) {
                        Image(systemName: task.isRunning ? "pause.circle.fill" : "timer")
                            .font(.title2)
                            .foregroundColor(task.isRunning ? .orange : .blue)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .sheet(isPresented: $isEditing) {
            if let binding = viewModel.binding(for: task) {
                TaskEditView(task: binding, viewModel: viewModel)
            }
        }
        .buttonStyle(.plain)
    }
}
