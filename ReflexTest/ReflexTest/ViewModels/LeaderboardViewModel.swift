import Foundation

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var records: [ReactionRecord] = []
    @Published var sortMode: LeaderboardSortMode = .byAverage
    @Published var showClearConfirmation = false

    var sortedRecords: [ReactionRecord] {
        switch sortMode {
        case .byAverage:
            return records.sorted { $0.averageTimeMs < $1.averageTimeMs }
        case .byBest:
            return records.sorted { $0.bestTimeMs < $1.bestTimeMs }
        }
    }

    var personalBest: ReactionRecord? {
        records.min(by: { $0.averageTimeMs < $1.averageTimeMs })
    }

    var isEmpty: Bool {
        records.isEmpty
    }

    func loadRecords() {
        records = StorageService.shared.loadRecords()
    }

    func deleteRecord(_ record: ReactionRecord) {
        StorageService.shared.deleteRecord(id: record.id)
        records.removeAll { $0.id == record.id }
    }

    func clearAll() {
        StorageService.shared.clearAll()
        records = []
    }
}
