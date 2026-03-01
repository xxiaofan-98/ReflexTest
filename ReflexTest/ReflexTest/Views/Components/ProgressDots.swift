import SwiftUI

struct ProgressDots: View {
    let totalRounds: Int
    let currentRound: Int
    let completedRounds: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalRounds, id: \.self) { round in
                Circle()
                    .fill(fillColor(for: round))
                    .frame(width: 10, height: 10)
                    .overlay(
                        Circle()
                            .stroke(strokeColor(for: round), lineWidth: 1.5)
                    )
            }
        }
    }

    private func fillColor(for round: Int) -> Color {
        if round <= completedRounds {
            return Color.theme.accentGreen
        } else if round == currentRound {
            return Color.theme.textPrimary.opacity(0.3)
        }
        return Color.clear
    }

    private func strokeColor(for round: Int) -> Color {
        if round <= completedRounds {
            return Color.theme.accentGreen
        } else if round == currentRound {
            return Color.theme.textPrimary
        }
        return Color.theme.border
    }
}
