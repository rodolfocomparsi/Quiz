import Foundation
import RealmSwift

class DatabaseService {
    let realm = try! Realm()
    
    func savePlayer(_ player: Player) {
        try! realm.write {
            realm.add(player)
        }
    }
    
    func fetchPlayers() -> Results<Player> {
        return realm.objects(Player.self).sorted(byKeyPath: "score", ascending: false)
    }
}
