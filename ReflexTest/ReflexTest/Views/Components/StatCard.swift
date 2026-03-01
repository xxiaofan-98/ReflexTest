import SwiftUI

struct StatCard: View {
    let title: String
    let value: Int
    let suffix: String

    init(title: String, value: Int, suffix: String = "ms") {
        self.title = title
        self.value = value
        self.suffix = suffix
    }

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.textSecondary)
                .textCase(.uppercase)

            Text("\(value) \(suffix)")
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .foregroundColor(Color.theme.textPrimary)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.theme.surface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.theme.border, lineWidth: 1)
        )
    }
}
