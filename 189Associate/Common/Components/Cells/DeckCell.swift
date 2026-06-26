import SwiftUI

struct DeckCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let deck: WordDeck
    var onTap: () -> Void
    var onEdit: () -> Void
    var onShare: () -> Void
    var onDelete: (() -> Void)? = nil

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(themeManager.accentColor.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Text(deck.icon)
                        .font(.title2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(deck.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack(spacing: 8) {
                        Label("\(deck.words.count)", systemImage: "text.word.spacing")
                        Text(updatedLabel)
                    }
                    .font(.caption)
                    .foregroundColor(.appTextSecondary)
                }

                Spacer()

                HStack(spacing: 4) {
                    iconButton("square.and.arrow.up", action: onShare)
                    iconButton("pencil", action: onEdit)
                }
            }
            .padding(AppDesign.cellPadding)
            .glassCard()
        }
        .buttonStyle(PressableCellStyle())
        .contextMenu {
            Button(action: onEdit) { Label("Edit", systemImage: "pencil") }
            Button(action: onShare) { Label("Export", systemImage: "square.and.arrow.up") }
            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    private var updatedLabel: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: deck.updatedAt, relativeTo: Date())
    }

    private func iconButton(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(themeManager.accentColor)
                .frame(width: 36, height: 36)
                .background(themeManager.accentColor.opacity(0.12))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
