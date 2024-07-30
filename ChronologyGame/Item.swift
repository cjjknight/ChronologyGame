import Foundation

struct Event: Identifiable {
    var id = UUID()
    var description: String
    var year: Int
}
