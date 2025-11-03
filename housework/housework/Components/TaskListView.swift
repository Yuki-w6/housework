import SwiftUI

struct TaskListView: View {
    @Binding var tasks: [Task]
    var onToggle: (Task) -> Void
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                HStack {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isDone ? .green : .gray)
                        .onTapGesture {
                            onToggle(task)
                        }
                    Text(task.title)
                        .strikethrough(task.isDone, color: .gray)
                        .foregroundColor(task.isDone ? .gray : .primary)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
        .navigationTitle("今日のタスク")
    }
}
