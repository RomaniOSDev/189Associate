import SwiftUI

struct AssociationResultCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let index: Int
    let text: String
    let isCorrect: Bool
    let points: Int
    let feedback: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: isCorrect
                                ? [Color.appCorrect.opacity(0.35), Color.appCorrect.opacity(0.12)]
                                : [Color.appIncorrect.opacity(0.35), Color.appIncorrect.opacity(0.12)],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 24
                        )
                    )
                    .overlay {
                        Circle()
                            .stroke(
                                (isCorrect ? Color.appCorrect : Color.appIncorrect).opacity(0.35),
                                lineWidth: 1
                            )
                    }
                    .frame(width: 32, height: 32)
                Text("\(index)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isCorrect ? .appCorrect : .appIncorrect)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(text)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .appCorrect : .appIncorrect)
                        Text("+\(points)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .appCorrect : .appIncorrect)
                    }
                }
                Text(feedback)
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(12)
        .glassCard(
            isSelected: isCorrect,
            accentGlow: isCorrect,
            elevation: isCorrect ? .floating : .raised,
            cornerRadius: AppDesign.cornerRadiusSmall
        )
    }
}

struct ExpectedAssociationCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let word: String
    let hint: String
    var matched: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: matched ? "checkmark.seal.fill" : "lightbulb.fill")
                .foregroundColor(matched ? .appCorrect : themeManager.accentColor)
                .font(.title3)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(word)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(hint)
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .glassCard(cornerRadius: AppDesign.cornerRadiusSmall)
    }
}
