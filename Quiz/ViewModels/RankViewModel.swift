
import Foundation
import RealmSwift

final class RankViewModel: ObservableObject {
    @Published var players: [Player] = []
    private let databaseService = DatabaseService()

    func loadPlayers() {
        players = Array(databaseService.fetchPlayers())
    }
}
