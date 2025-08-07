
import SwiftUI

struct ResultView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var editedName: String = ""
    
    var body: some View {
        VStack {
            Text("Parabéns, \(quizViewModel.name)!")
                .font(.headline)
                .padding()
            Text("Você acertou \(quizViewModel.score) de 10 perguntas.")
                .font(.subheadline)
                .padding()
            
            TextField("Editar nome", text: $editedName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            VStack {
                Button(action: {
                    if !editedName.isEmpty {
                        quizViewModel.name = editedName
                    }
                    quizViewModel.restartQuiz()
                }) {
                    Text("Recomeçar Quiz")
                        .padding(.horizontal,5)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Button(action: {
                    quizViewModel.showStartView = true
                    quizViewModel.isQuizStarted = false
                    if !editedName.isEmpty {
                        quizViewModel.name = editedName
                    }
                }){
                    Text("Voltar à Tela Principal")
                        .padding(.horizontal,5)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                
            }
            .frame(maxWidth: 200 ,maxHeight: 80, alignment: .center)
            
        }
        .padding()
        .onAppear {
            editedName = quizViewModel.name
        }
    }
}
#Preview{
    ResultView(quizViewModel: QuizViewModel())
}
