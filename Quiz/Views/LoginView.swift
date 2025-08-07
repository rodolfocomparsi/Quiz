
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var showPlayerListView = false

    var body: some View {
        ZStack {
            Color.secondary.opacity(0.5)
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(alignment: .center, spacing: 50) {
                Spacer()
                Image("quiz")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .aspectRatio(contentMode: .fit)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Material.thinMaterial)
                    .frame(width: 300, height: 200)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
                    .overlay {
                        VStack {
                            Text("Bem-vindo, \(quizViewModel.name)!")
                                .font(.headline)
                                .padding()
                            
                            Button("Iniciar Quiz") {
                                quizViewModel.startQuiz()
                            }
                            .padding()
                            .disabled(quizViewModel.questions.isEmpty)
                            .opacity(quizViewModel.questions.isEmpty ? 0.5 : 1.0)
                        }
                        .padding()
                    }
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPlayerListView = true
                }) {
                    Image(systemName: "person")
                }
            }
        }
        .sheet(isPresented: $showPlayerListView) {
            RankView()
        }
    }
}
