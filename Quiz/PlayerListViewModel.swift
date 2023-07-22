import RealmSwift
import Foundation

class Player: Object {
    @Persisted var name: String = ""
    @Persisted var score: Int = 0
}

final class PlayerListViewModel: ObservableObject {
    @Published var players: [Player] = []
    
    func loadPlayers() {
        let realm = try! Realm()
        players = Array(realm.objects(Player.self))
    }
}
