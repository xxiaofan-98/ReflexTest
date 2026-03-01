import Foundation

enum GameState: Equatable {
    case idle
    case countdown(Int)
    case waiting
    case ready
    case tapped(Int)
    case tooEarly
}

enum RoundPhase {
    case notStarted
    case inProgress
    case completed
}

enum AppRoute: Hashable {
    case home
    case game
    case results(ResultData)
    case leaderboard
}

struct ResultData: Hashable {
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
}
