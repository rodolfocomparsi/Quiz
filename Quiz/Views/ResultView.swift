
import SwiftUI

struct ResultView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var editedName: String = ""
    @State private var trophyScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20){
            Spacer()
            VStack {
                VStack{
                    
                    Text("Parabéns, \(quizViewModel.name)")
                        .font(.system(size: 20).bold())
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    HStack{
                        Text("Você fez")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("+\(quizViewModel.score * 10)")
                            .font(.headline)
                            .foregroundColor(quizViewModel.score >= 6 ? .green : .red)
                        Text("pontos.")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.top,40)
            
                Divider()
                    .overlay(.white)
                    .frame(height: 1)
                    .opacity(0.5)
                    .padding(.top,10)
                
                HStack{
                    ResultItem(nameType: "Perguntas", score: 10 , color: .white)
                    
                    Divider()
                        .overlay(.white)
                        .frame(width: 1)
                        .opacity(0.5)
                    
                    ResultItem(nameType: "Corretas", score: quizViewModel.score, color: .dynamoxGreen.opacity(0.8))
                    
                    Divider()
                        .overlay(.white)
                        .frame(width: 1)
                        .opacity(0.5)
                    
                    ResultItem(nameType: "Erradas", score: abs(10 - quizViewModel.score), color: .red.opacity(0.8))

                }
                .frame(width: 58)
                .padding(.top,-9)

               
                
            }
            .frame(width: 300, height: 197, alignment: .center)
            .background(Color("DynamoxColor"))
            .cornerRadius(8)
            
            
            Button("Jogar de novo") {
                quizViewModel.restartQuiz()
            }
            .padding()
            .frame(maxWidth: 299, maxHeight: 48)
            .background(Color("DynamoxColor"))
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Voltar ao início") {
                quizViewModel.showStartView = true
                quizViewModel.isQuizStarted = false
                if !editedName.isEmpty {
                    quizViewModel.name = editedName
                }
            }
            .padding()
            .frame(maxWidth: 299, maxHeight: 48)
            .background(Color.white)
            .foregroundColor(Color("DynamoxColor"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke( Color("DynamoxColor"), lineWidth: 2)
            )
            .cornerRadius(8)



            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Image("DynamoxLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                }
            }
        }
        .overlay(alignment: .top) {
            VStack {
                Image("Trophy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 92, height: 92)
                    .scaleEffect(trophyScale)
                    .onAppear {
                        withAnimation(
                            .easeInOut(duration: 0.9)
                            .repeatForever(autoreverses: true)
                        ) {
                            trophyScale = 1.3
                        }
                    }
            }
        }
        .onAppear {
            trophyScale = 1.1
            withAnimation(.spring(response: 0.5, dampingFraction: 0.4)) {
                trophyScale = 1.1
            }
        }
        .frame(width: 300, height: 375)
        .padding(.top,-150)

    }
}
#Preview{
    ResultView(quizViewModel: QuizViewModel())
}


