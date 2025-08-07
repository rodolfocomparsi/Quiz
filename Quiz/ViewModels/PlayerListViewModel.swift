
import Foundation
import RealmSwift

final class PlayerListViewModel: ObservableObject {
    @Published var players: [Player] = []
    private let databaseService = DatabaseService()

    func loadPlayers() {
        players = Array(databaseService.fetchPlayers())
    }
}
