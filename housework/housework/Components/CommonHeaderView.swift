import SwiftUI

struct CommonHeaderView: View {
    var title: String
    var showBackButton: Bool = false
    var trailingButtonTitle: String? = nil
    var trailingButtonColor: Color = .blue
    var onBack: (() -> Void)? = nil
    var onTrailingButtonTap: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // ヘッダー本体
            HStack {
                // 左：戻る
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.appText)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.plain)
                } else {
                    Spacer().frame(width: 28)
                }
                
                // 中央：タイトル
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.appText)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                // 右：テキストボタン or ダミー
                if let trailingTitle = trailingButtonTitle {
                    Button(action: { onTrailingButtonTap?() }) {
                        Text(trailingTitle)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(trailingButtonColor)
                            .lineLimit(1)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 44, alignment: .trailing)
                } else {
                    Spacer().frame(width: 44)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 48)                    // ← 完全固定
        .background(Color.appCard)            // ライト/ダーク対応
        .overlay(Divider(), alignment: .bottom)
    }
}
