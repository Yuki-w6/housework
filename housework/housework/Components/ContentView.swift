import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var path: [HWTask] = []   // 画面遷移用（iOS16+）
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // ✅ 固定ヘッダー（スクロール外）
                    CommonHeaderView(title: "今日")
                        .background(Color.appCard)
                        .zIndex(1)
                    
                    // ✅ スクロールする本体
                    ScrollView {
                        VStack(spacing: 16) {
                            SummaryView(viewModel: viewModel)
                            AddTaskView(viewModel: viewModel)
                            
                            TaskListView(
                                viewModel: viewModel,
                                onSelect: { task in path.append(task) }
                            )
                        }
                        .padding(.vertical)
                    }
                }
            }
            // ✅ 画面遷移
            .navigationDestination(for: HWTask.self) { task in
                if let binding = viewModel.binding(for: task) {
                    HWTaskEditView(task: binding, viewModel: viewModel)
                } else {
                    Text("タスクが見つかりません")
                }
            }
            // ✅ システムのナビバーは非表示（共通ヘッダーのみ）
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
