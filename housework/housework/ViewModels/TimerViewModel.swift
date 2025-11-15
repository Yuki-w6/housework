import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    /// 今タイマーが紐づいているタスクID（なければ nil）
    @Published var currentTaskID: UUID?
    /// タイマーが動作中かどうか
    @Published private(set) var isRunning: Bool = false
    
    /// 1秒ごとの tick で呼ばれるコールバック
    /// （TaskViewModel がここに「指定されたタスクIDの executedSeconds を +1 する処理」を入れる）
    var tickHandler: ((UUID) -> Void)?
    
    private var timer: Timer?
    
    /// 指定したタスクIDでタイマーを開始（すでにタイマーが動いていれば紐づけだけ変更）
    func start(for taskID: UUID) {
        currentTaskID = taskID
        isRunning = true
        
        // まだタイマーがなければ生成
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self,
                      let id = self.currentTaskID else { return }
                self.tickHandler?(id)
            }
        }
    }
    
    /// 動作中のタイマーを止めずに、紐づけるタスクだけを変更
    func changeTask(to taskID: UUID) {
        if isRunning {
            currentTaskID = taskID
        } else {
            // 止まっている状態で呼ばれたら、普通に start と同じ動きにしてもOK
            start(for: taskID)
        }
    }
    
    /// タイマーを完全停止
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        currentTaskID = nil
    }
    
    deinit {
        timer?.invalidate()
    }
}
