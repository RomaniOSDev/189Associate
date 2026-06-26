import SwiftUI

struct TimerCountdownView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let timeLeft: Int
    var maxTime: Int = 30

    private var isUrgent: Bool { timeLeft <= 5 }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.14),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 52, height: 52)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: isUrgent
                                ? [.appIncorrect, .appIncorrect.opacity(0.55), .appIncorrect]
                                : [
                                    themeManager.accentColor.lightened(by: 0.1),
                                    themeManager.accentColor,
                                    themeManager.accentColor.darkened(by: 0.08),
                                    themeManager.accentColor.lightened(by: 0.1)
                                ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 52, height: 52)
                    .rotationEffect(.degrees(-90))

                Text("\(timeLeft)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: isUrgent
                                ? [.appIncorrect, .appIncorrect.opacity(0.8)]
                                : [.white, themeManager.accentColor.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .compositingGroup()
            .shadow(color: (isUrgent ? Color.appIncorrect : themeManager.accentColor).opacity(0.3), radius: 8, y: 3)

            Text("sec")
                .font(.caption2)
                .foregroundColor(.appTextSecondary)
        }
    }

    private var progress: CGFloat {
        guard maxTime > 0 else { return 1 }
        return CGFloat(timeLeft) / CGFloat(maxTime)
    }
}
