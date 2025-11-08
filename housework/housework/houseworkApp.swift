import SwiftUI

@main
struct houseworkApp: App {
    init() {
        NotificationManager.shared.requestPermission() // ← 通知許可リクエスト
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
