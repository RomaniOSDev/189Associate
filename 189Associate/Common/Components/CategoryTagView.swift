import SwiftUI

struct CategoryTagView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let category: Category
    var label: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            Text(category.icon)
            Text(label ?? category.displayName)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(themeManager.accentColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(themeManager.accentColor.opacity(0.12))
        .clipShape(Capsule())
    }
}
