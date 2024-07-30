import Foundation

struct ChronologyEvent: Identifiable {
    var id = UUID()
    var description: String
    var year: Int
}
