import SwiftUI

struct RoundResultRow: View {
    let roundNumber: Int
    let timeMs: Int
    let isBest: Bool
    let isWorst: Bool

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(dotColor)
                    .frame(width: 8, height: 8)

                Text("Round \(roundNumber)")
                    .font(.body)
                    .foregroundColor(Color.theme.textSecondary)
            }

            Spacer()

            Text("\(timeMs) ms")
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.textPrimary)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.theme.surface)
        .cornerRadius(10)
    }

    private var dotColor: Color {
        if isBest { return Color.theme.accentGreen }
        if isWorst { return Color.theme.accentRed }
        return Color.theme.textSecondary
    }
}
