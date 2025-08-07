
import Foundation
import RealmSwift

class Player: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var score: Int = 0
}
