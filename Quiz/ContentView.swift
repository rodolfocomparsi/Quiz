import SwiftUI

struct ContentView: View {
    @StateObject private var quizViewModel = QuizViewModel()
    @State var startQuiz: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.secondary.opacity(0.5)
                    .ignoresSafeArea(.all, edges: .all)
                
                VStack(alignment: .center, spacing: 50) {
                    Image("quiz")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                        .rotationEffect(.degrees(quizViewModel.isAnimated ? 360 : 0))
                        .animation(
                            .easeOut(duration: 2)
                            .repeatForever(autoreverses: true),
                            value: quizViewModel.isAnimated
                        )
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Material.thinMaterial)
                        .frame(width: 300, height: 200)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
                        .overlay {
                            VStack {
                                TextField("Digite seu nome", text: $quizViewModel.playerName)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Iniciar Quiz") {
                                    quizViewModel.startQuiz()
                                    self.startQuiz = true
                                }
                                .padding()
                                .disabled(quizViewModel.playerName.isEmpty)
                                .opacity(quizViewModel.playerName.isEmpty ? 1.0 : 0.5)
                                
                                NavigationLink(
                                    destination: QuizView(quizViewModel: quizViewModel),
                                    isActive: $startQuiz,
                                    label: { EmptyView() }
                                )
                                .navigationBarHidden(true)
                            }
                            .padding()
                        }
                        .scaleEffect(quizViewModel.isAnimated ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 3), value: quizViewModel.isAnimated)
                        .padding()
                    
                    Spacer()
                }
            }
            .onAppear {
                quizViewModel.isAnimated = true
            }
        }
    }
}
