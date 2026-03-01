import Foundation

final class StorageService {
    static let shared = StorageService()

    private let key = "reaction_records"
    private let maxRecords = 100

    private init() {}

    func loadRecords() -> [ReactionRecord] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let records = (try? JSONDecoder().decode([ReactionRecord].self, from: data)) ?? []
        return records.sorted { $0.date > $1.date }
    }

    func saveRecord(_ record: ReactionRecord) {
        var records = loadRecords()
        records.insert(record, at: 0)
        if records.count > maxRecords {
            records = Array(records.prefix(maxRecords))
        }
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func deleteRecord(id: UUID) {
        var records = loadRecords()
        records.removeAll { $0.id == id }
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
