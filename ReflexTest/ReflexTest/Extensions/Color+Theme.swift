import SwiftUI

extension Color {
    static let theme = ThemeColors()
}

struct ThemeColors {
    let background = Color(hex: "000000")
    let surface = Color(hex: "1C1C1E")
    let surfaceSecondary = Color(hex: "2C2C2E")
    let border = Color(hex: "3A3A3C")
    let textPrimary = Color(hex: "FFFFFF")
    let textSecondary = Color(hex: "8E8E93")
    let accentGreen = Color(hex: "2ACF5A")
    let accentRed = Color(hex: "CF2A2A")
    let accentAmber = Color(hex: "F5A623")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
