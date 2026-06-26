import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    func lightened(by amount: Double) -> Color {
        adjustBrightness(by: abs(amount))
    }

    func darkened(by amount: Double) -> Color {
        adjustBrightness(by: -abs(amount))
    }

    private func adjustBrightness(by amount: Double) -> Color {
#if canImport(UIKit)
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }

        let adjusted = min(max(brightness + CGFloat(amount), 0), 1)
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(adjusted), opacity: Double(alpha))
#else
        return self
#endif
    }
}
