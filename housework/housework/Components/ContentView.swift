import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HeaderView()
                    SummaryView(viewModel: viewModel)
                    AddTaskView(viewModel: viewModel)
                    TaskListView(viewModel: viewModel)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    ContentView()
}
