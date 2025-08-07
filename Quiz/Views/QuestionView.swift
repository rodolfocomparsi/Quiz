
import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuizViewModel
    let question: Question
    @State private var selectedAnswer: String?
    
    var body: some View {
        VStack {
            Text(question.statement)
                .font(.headline)
                .padding()
            ForEach(question.options, id: \.self) { option in
                Button(action: {
                    if selectedAnswer == nil {
                        selectedAnswer = option
                        _ = viewModel.checkAnswer(option)
                    }
                }) {
                    Text(option)
                        .padding()
                        .background(selectedAnswer == option ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(selectedAnswer != nil)
            }
            Text("Pontuação: \(viewModel.score)")
                .padding()
            if viewModel.isQuizFinished {
                NavigationLink(destination: ResultView(viewModel: viewModel)) {
                    Text("Ver Resultado")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(viewModel: QuizViewModel(), question: Question(id: "1", statement: "Teste?", options: ["A", "B"], correctAnswer: nil))
    }
}
