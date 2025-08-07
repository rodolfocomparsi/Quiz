
import Foundation

struct Question: Codable, Equatable {
    let id: String
    let statement: String
    let options: [String]
    let correctAnswer: String?
}
