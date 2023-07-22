import SwiftUI
import RealmSwift

struct PlayerListView: View {
    @StateObject private var viewModel = PlayerListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.players, id: \.self) { player in 
                Text("\(player.name): \(player.score)")
            }
            .navigationBarTitle("Players")
        }
        .onAppear {
            viewModel.loadPlayers()
        }
    }
}

struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView()
    }
}
