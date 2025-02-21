import Foundation
import Firebase

struct User: Hashable, Codable {
    var id: String?
    var firstName: String
    var lastName: String
    var email: String
}

struct CustomAlertInfo {
    var title: String
    var description: String
}

struct Log: Hashable, Identifiable {
    var id: String
    var date: Date
    var liters: Float
    var distance: Float
    var cost: Float
    var fuel: String
}
