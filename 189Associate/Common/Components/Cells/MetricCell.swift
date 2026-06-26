import SwiftUI

struct MetricCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let icon: String
    let value: String
    let label: String
    var valueColor: Color? = nil
    var compact: Bool = false

    var body: some View {
        VStack(spacing: compact ? 4 : 8) {
            Text(icon)
                .font(compact ? .title3 : .title2)
            Text(value)
                .font(.system(size: compact ? 22 : 28, weight: .bold, design: .rounded))
                .foregroundColor(valueColor ?? .white)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, compact ? 10 : 14)
    }
}

struct MetricRowCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let metrics: [(icon: String, value: String, label: String, color: Color?)]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(metrics.enumerated()), id: \.offset) { index, metric in
                MetricCell(
                    icon: metric.icon,
                    value: metric.value,
                    label: metric.label,
                    valueColor: metric.color,
                    compact: true
                )
                if index < metrics.count - 1 {
                    Rectangle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 1, height: 48)
                }
            }
        }
        .padding(.vertical, 4)
        .glassCard(elevation: .floating)
    }
}

struct InsightStatCell: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let title: String
    let value: String
    let detail: String
    var accent: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.appTextSecondary)
                .tracking(0.6)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(accent ? themeManager.accentColor : .white)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            Text(detail)
                .font(.caption)
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppDesign.cellPadding)
        .glassCard(accentGlow: accent)
    }
}
