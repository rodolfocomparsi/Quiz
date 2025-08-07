
import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack {
            Text("Fim do Quiz!")
                .font(.largeTitle)
                .padding()
            Text("Parabéns, \(viewModel.name)!")
                .font(.title)
                .padding()
            Text("Sua pontuação: \(viewModel.score) de \(viewModel.questions.count)")
                .font(.title2)
                .padding()
            Button("Reiniciar Quiz") {
                viewModel.saveScore()
                viewModel.name = ""
                viewModel.isQuizStarted = false
                viewModel.questions.removeAll()
                viewModel.currentQuestionIndex = 0
                viewModel.score = 0
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            viewModel.saveScore()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(viewModel: QuizViewModel())
    }
}
