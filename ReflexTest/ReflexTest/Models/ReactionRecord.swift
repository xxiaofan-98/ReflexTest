import Foundation

struct ReactionRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let roundTimes: [Int]

    var averageTimeMs: Int {
        guard !roundTimes.isEmpty else { return 0 }
        return roundTimes.reduce(0, +) / roundTimes.count
    }

    var bestTimeMs: Int {
        roundTimes.min() ?? 0
    }

    var worstTimeMs: Int {
        roundTimes.max() ?? 0
    }

    var medianTimeMs: Int {
        guard !roundTimes.isEmpty else { return 0 }
        let sorted = roundTimes.sorted()
        let mid = sorted.count / 2
        if sorted.count.isMultiple(of: 2) {
            return (sorted[mid - 1] + sorted[mid]) / 2
        }
        return sorted[mid]
    }

    init(roundTimes: [Int]) {
        self.id = UUID()
        self.date = Date()
        self.roundTimes = roundTimes
    }

    static func ratingFor(ms: Int) -> String {
        switch ms {
        case ..<200: return "Incredible!"
        case 200..<300: return "Great!"
        case 300..<400: return "Good"
        case 400..<500: return "Average"
        default: return "Keep practicing"
        }
    }
}
