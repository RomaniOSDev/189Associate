import SwiftUI

struct AssociationInputView: View {
    @Binding var text: String
    let isDisabled: Bool
    let onSubmit: () -> Void
    @FocusState.Binding var isFocused: Bool
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(spacing: AppDesign.itemSpacing) {
            HStack(spacing: 12) {
                Image(systemName: "pencil.line")
                    .foregroundColor(themeManager.accentColor)
                TextField("Enter an association...", text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .focused($isFocused)
                    .disabled(isDisabled)
                    .onSubmit(onSubmit)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(AppDesign.cellPadding)
            .glassCard(elevation: .raised, cornerRadius: AppDesign.cornerRadiusSmall)

            Button(action: onSubmit) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Association")
                        .fontWeight(.semibold)
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background {
                    PrimaryGradientFill(isEnabled: !isDisabled)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadiusSmall, style: .continuous))
                .topInnerHighlight(cornerRadius: AppDesign.cornerRadiusSmall, opacity: isDisabled ? 0.08 : 0.24)
                .depthShadow(
                    elevation: isDisabled ? .flat : .floating,
                    accentColor: themeManager.accentColor,
                    accentGlow: !isDisabled
                )
            }
            .disabled(isDisabled)
            .buttonStyle(PressableCellStyle())
        }
    }
}
