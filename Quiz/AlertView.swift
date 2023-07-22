import SwiftUI

struct AlertView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    
    var body: some View {
        VStack {
            if !quizViewModel.isQuizFinished && quizViewModel.currentQuestionIndex < quizViewModel.questions.count {
                QuestionView(
                    question: quizViewModel.questions[quizViewModel.currentQuestionIndex]
                ) { selectedAnswer in
                    quizViewModel.loadNextQuestion(selectedAnswer: selectedAnswer)
                }
                .onReceive(quizViewModel.$currentQuestionIndex) { _ in
                    quizViewModel.isAnimated.toggle()
                }
                .onAppear {
                    quizViewModel.isAnimated = true
                }
            } else if quizViewModel.isQuizFinished {
                VStack {
                    Text("Parabéns, \(quizViewModel.playerName)!")
                        .font(.headline)
                        .padding()
                    Text("Você acertou \(quizViewModel.score) perguntas.")
                        .font(.subheadline)
                        .padding()
                    Button("Recomeçar Quiz") {
                        quizViewModel.restartQuiz()
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}
