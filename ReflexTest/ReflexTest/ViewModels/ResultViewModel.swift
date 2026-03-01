import Foundation

@MainActor
final class ResultViewModel: ObservableObject {
    let resultData: ResultData

    var shareText: String {
        let roundsStr = resultData.roundTimes.map { "\($0)" }.joined(separator: " | ")
        return """
        ReflexTest Results
        ---
        Average: \(resultData.averageTimeMs) ms
        Best: \(resultData.bestTimeMs) ms
        Rounds: \(roundsStr) ms

        Can you beat my reaction time?
        """
    }

    init(resultData: ResultData) {
        self.resultData = resultData
    }
}
