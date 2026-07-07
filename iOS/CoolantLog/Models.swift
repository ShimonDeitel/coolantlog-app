import Foundation

struct FlushEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var notes: String = ""
    var coolantType: String
    var mileage: Double
}
