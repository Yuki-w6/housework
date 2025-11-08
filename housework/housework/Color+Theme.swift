import SwiftUI

extension Color {
    /// 背景（全体）
    static var appBackground: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? .black : .systemGray6
        })
    }
    
    /// カード・ヘッダー共通色
    static var appCard: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
        })
    }
    
    /// テキスト色（黒 / 白）
    static var appText: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? .white : .black
        })
    }
}
