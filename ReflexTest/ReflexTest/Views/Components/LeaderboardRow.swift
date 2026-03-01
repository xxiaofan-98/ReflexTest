import SwiftUI

struct LeaderboardRow: View {
    let rank: Int
    let record: ReactionRecord
    let displayMode: LeaderboardSortMode

    var body: some View {
        HStack(spacing: 12) {
            rankView
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(primaryText)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.textPrimary)
                    .monospacedDigit()

                Text(record.date.relativeFormatted)
                    .font(.caption)
                    .foregroundColor(Color.theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(secondaryText)
                    .font(.caption)
                    .foregroundColor(Color.theme.textSecondary)

                Text("\(record.roundTimes.count) rounds")
                    .font(.caption2)
                    .foregroundColor(Color.theme.textSecondary.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.theme.surface)
        .cornerRadius(12)
    }

    @ViewBuilder
    private var rankView: some View {
        if rank <= 3 {
            Image(systemName: "medal.fill")
                .font(.title3)
                .foregroundColor(medalColor)
        } else {
            Text("#\(rank)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.textSecondary)
        }
    }

    private var medalColor: Color {
        switch rank {
        case 1: return Color.theme.accentAmber
        case 2: return Color(hex: "C0C0C0")
        case 3: return Color(hex: "CD7F32")
        default: return Color.theme.textSecondary
        }
    }

    private var primaryText: String {
        switch displayMode {
        case .byAverage: return "\(record.averageTimeMs) ms avg"
        case .byBest: return "\(record.bestTimeMs) ms best"
        }
    }

    private var secondaryText: String {
        switch displayMode {
        case .byAverage: return "Best: \(record.bestTimeMs) ms"
        case .byBest: return "Avg: \(record.averageTimeMs) ms"
        }
    }
}

enum LeaderboardSortMode: String, CaseIterable {
    case byAverage = "By Average"
    case byBest = "By Best"
}
