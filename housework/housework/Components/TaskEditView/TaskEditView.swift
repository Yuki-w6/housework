import SwiftUI

struct HWTaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var task: HWTask
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var showDurationSheet = false
    @State private var showReminderSheet = false
    @State private var showRepeatSheet = false
    
    @State private var tempPlannedMinutes: Int = 30
    @State private var tempReminderTime = Date()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            // ✅ ヘッダーを最上部に固定し、その下をスクロールさせる
            VStack(spacing: 0) {
                CommonHeaderView(
                    title: "タスク",
                    showBackButton: true,
                    trailingButtonTitle: "削除",
                    trailingButtonColor: .red,
                    onBack: { dismiss() },
                    onTrailingButtonTap: {
                        viewModel.deleteTask(task)
                        dismiss()
                    }
                )
                .background(Color.appCard)
                .zIndex(1)
                
                ScrollView {
                    VStack(spacing: 12) {
                        TaskTitleCardView(task: $task) {
                            viewModel.updateTask(task)
                        }
                        
                        TaskSettingCardView(
                            task: $task,
                            showDurationSheet: $showDurationSheet,
                            showReminderSheet: $showReminderSheet,
                            showRepeatSheet: $showRepeatSheet,
                            tempPlannedMinutes: $tempPlannedMinutes,
                            tempReminderTime: $tempReminderTime
                        )
                        
                        TaskMemoCardView(task: $task)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: task) { _, newValue in
            viewModel.updateTask(newValue)
        }
        .onChange(of: showDurationSheet) { _, isOpen in
            if isOpen { tempPlannedMinutes = task.plannedMinutes }
        }
        .onChange(of: showReminderSheet) { _, isOpen in
            if isOpen { tempReminderTime = task.reminderDate ?? Date() }
        }
        .sheet(isPresented: $showDurationSheet) {
            DurationSettingSheet(
                selectedMinutes: $tempPlannedMinutes,
                onConfirm: {
                    task.plannedMinutes = tempPlannedMinutes
                    showDurationSheet = false
                },
                onCancel: { showDurationSheet = false }
            )
            .presentationDetents([.fraction(0.3)])
        }
        .sheet(isPresented: $showReminderSheet) {
            ReminderTimeSheet(
                selectedDate: $tempReminderTime,
                onConfirm: {
                    task.reminderDate = tempReminderTime
                    showReminderSheet = false
                },
                onCancel: { showReminderSheet = false }
            )
            .presentationDetents([.fraction(0.3)])
        }
        .sheet(isPresented: $showRepeatSheet) {
            RepeatSettingView(task: $task)
                .presentationDetents([.fraction(0.4)])
        }
    }
}
