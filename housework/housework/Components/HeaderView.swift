import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("今日")
                .font(.largeTitle.bold())
                .padding(.vertical, 12)
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}
