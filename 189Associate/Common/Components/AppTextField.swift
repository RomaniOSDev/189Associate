import SwiftUI

struct AppTextField: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(themeManager.accentColor)
                    .frame(width: 20)
            }
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .foregroundColor(.white)
                .autocorrectionDisabled()
        }
        .padding(AppDesign.cellPadding)
        .glassCard(elevation: .raised, cornerRadius: AppDesign.cornerRadiusSmall)
    }
}
