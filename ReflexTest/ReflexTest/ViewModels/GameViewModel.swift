import SwiftUI

@MainActor
final class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .idle
    @Published var currentRound: Int = 0
    @Published var roundTimes: [Int] = []

    private let totalRounds = 5
    private var waitingTask: Task<Void, Never>?
    private var readyTimestamp: Date?
    private var tooEarlyCooldown = false

    var isSessionComplete: Bool {
        roundTimes.count >= totalRounds
    }

    var resultData: ResultData {
        ResultData(roundTimes: roundTimes)
    }

    func reset() {
        waitingTask?.cancel()
        waitingTask = nil
        readyTimestamp = nil
        tooEarlyCooldown = false
        gameState = .idle
        currentRound = 0
        roundTimes = []
    }

    func handleTap() {
        switch gameState {
        case .idle:
            startCountdown()
        case .countdown:
            break
        case .waiting:
            handleTooEarly()
        case .ready:
            handleSuccessfulTap()
        case .tapped:
            if isSessionComplete {
                return
            }
            startCountdown()
        case .tooEarly:
            if !tooEarlyCooldown {
                startCountdown()
            }
        }
    }

    func pauseGame() {
        if case .waiting = gameState {
            waitingTask?.cancel()
            waitingTask = nil
            gameState = .idle
        }
    }

    private func startCountdown() {
        currentRound = roundTimes.count + 1
        gameState = .countdown(3)

        Task {
            for i in stride(from: 2, through: 1, by: -1) {
                try? await Task.sleep(nanoseconds: 800_000_000)
                if Task.isCancelled { return }
                gameState = .countdown(i)
            }
            try? await Task.sleep(nanoseconds: 800_000_000)
            if Task.isCancelled { return }
            startWaiting()
        }
    }

    private func startWaiting() {
        gameState = .waiting
        let delay = Double.random(in: 1.5...5.0)

        waitingTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            if Task.isCancelled { return }
            showReady()
        }
    }

    private func showReady() {
        readyTimestamp = Date()
        gameState = .ready
        HapticService.shared.targetAppeared()
    }

    private func handleSuccessfulTap() {
        guard let timestamp = readyTimestamp else { return }
        let elapsed = Int(Date().timeIntervalSince(timestamp) * 1000)
        roundTimes.append(elapsed)
        readyTimestamp = nil
        gameState = .tapped(elapsed)
        HapticService.shared.successfulTap()

        if isSessionComplete {
            HapticService.shared.sessionComplete()
            let record = ReactionRecord(roundTimes: roundTimes)
            StorageService.shared.saveRecord(record)
        }
    }

    private func handleTooEarly() {
        waitingTask?.cancel()
        waitingTask = nil
        readyTimestamp = nil
        gameState = .tooEarly
        tooEarlyCooldown = true
        HapticService.shared.tooEarly()

        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            tooEarlyCooldown = false
        }
    }
}
