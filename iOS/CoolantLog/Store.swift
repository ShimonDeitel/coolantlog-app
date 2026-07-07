import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [FlushEntry] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier allows up to this many saved entries. Kept comfortably above
    /// the seed data count so a fresh install never trips the paywall.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("coolantlog_entries.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || entries.count < Store.freeLimit
    }

    func add(_ entry: FlushEntry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: FlushEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: FlushEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            entries = Self.seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([FlushEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Self.seedData()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static func seedData() -> [FlushEntry] {
        [
        FlushEntry(date: Date().addingTimeInterval(-259200), notes: "", coolantType: "Sample Coolant type 1", mileage: 100.0),
        FlushEntry(date: Date().addingTimeInterval(-518400), notes: "", coolantType: "Sample Coolant type 2", mileage: 125.0)
        ]
    }
}
