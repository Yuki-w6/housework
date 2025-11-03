import SwiftUI

struct TaskRowView: View {
    let task: Task
    var toggleTask: (Task) -> Void
    var startTimer: (Task) -> Void
    var isCompleted: Bool = false
    
    var body: some View {
        HStack {
            Button(action: { toggleTask(task) }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            Text(task.title)
                .font(.headline)
                .strikethrough(task.isDone, color: .gray)
                .foregroundColor(task.isDone ? .gray : .primary)
            
            Spacer()
            
            if !isCompleted {
                Button(action: { startTimer(task) }) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
