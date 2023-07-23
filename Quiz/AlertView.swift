import SwiftUI
import RealmSwift

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
                    Text("Parabéns, \(quizViewModel.name)!")
                        .font(.headline)
                        .padding()
                    Text("Você acertou \(quizViewModel.score) perguntas.")
                        .font(.subheadline)
                        .padding()
                    Button("Recomeçar Quiz") {
                        quizViewModel.restartQuiz()
                    }
                    .padding()
                }.onAppear {
                    CoreDataManager.shared.savePlayer(name: quizViewModel.name, score: quizViewModel.score)
                }
            }
        }
        .padding()
        .alert(isPresented: $quizViewModel.isAlertPresented) {
            Alert(
                title: Text(quizViewModel.alertTitle),
                message: Text(quizViewModel.alertMessage),
                dismissButton: .cancel(Text("OK"))
            )
        }
    }
}
