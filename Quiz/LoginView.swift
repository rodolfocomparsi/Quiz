import SwiftUI

struct LoginView: View {
    @StateObject private var quizViewModel = QuizViewModel()
    @Binding var startQuiz: Bool
    @State var showPlayerListView = false
    var body: some View {
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
                                TextField("Digite seu nome", text: $quizViewModel.name)
                                    .padding()
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Iniciar Quiz") {
                                    quizViewModel.startQuiz()
                                    self.startQuiz = true
                                }
                                .padding()
                                .disabled(quizViewModel.name.isEmpty)
                                .opacity(quizViewModel.name.isEmpty ? 1.0 : 0.5)
                                
                                NavigationLink(
                                    destination: AlertView(quizViewModel: quizViewModel),
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showPlayerListView = true
                    }) {
                        Image(systemName: "person")
                    }
                }
            }
            .sheet(isPresented: $showPlayerListView) {
                PlayerListView()
            }
        
    }
}

