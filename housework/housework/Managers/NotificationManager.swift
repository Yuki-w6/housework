import UserNotifications
import Foundation

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    // 通知の許可をリクエスト
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知許可エラー: \(error)")
            } else {
                print("通知許可: \(granted)")
            }
        }
    }
    
    // 通知をスケジュール
    func scheduleNotification(for task: HWTask) {
        guard let reminderDate = task.reminderDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "家事リマインダー"
        content.body = task.title
        content.sound = .default
        
        // 時刻指定
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderDate)
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        // 既存通知を削除して再登録
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知登録失敗: \(error)")
            } else {
                print("通知登録成功: \(task.title)")
            }
        }
    }
    
    // 通知を削除
    func cancelNotification(for task: HWTask) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
    }
}
