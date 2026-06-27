import Foundation

struct User: Codable, Identifiable {
    var id: String = UUID().uuidString
    var fullName: String
    var email: String
    var passwordHash: String
}
