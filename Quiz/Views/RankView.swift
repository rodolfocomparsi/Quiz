
import SwiftUI

struct RankView: View {
    @StateObject private var viewModel = RankViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.players, id: \.id) { player in
                    HStack {
                        Text("\(player.name)")
                        Spacer()
                        Text("Score: \(player.score)")
                    }
                }
            }
            .navigationTitle("Rank")
        }
        .onAppear {
            viewModel.loadPlayers()
        }
    }
}
