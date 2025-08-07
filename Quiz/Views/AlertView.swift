
import SwiftUI

struct AlertView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    
    var body: some View {
        VStack {
            if !quizViewModel.isQuizFinished && quizViewModel.currentQuestionIndex < quizViewModel.questions.count {
                QuestionView(quizViewModel: quizViewModel,
                             question: quizViewModel.questions[quizViewModel.currentQuestionIndex],
                             answerHandler: { selectedAnswer in
                    quizViewModel.loadNextQuestion(selectedAnswer: selectedAnswer)
                })
                .onChange(of: quizViewModel.isAlertPresented) { newValue in
                    if !newValue {
                        quizViewModel.canProceed = true
                    }
                }
            } else if quizViewModel.isQuizFinished {
                ResultView(quizViewModel: quizViewModel)
            }
        }
        .padding()
        .alert(isPresented: $quizViewModel.isAlertPresented) {
            Alert(
                title: Text(quizViewModel.alertTitle),
                message: Text(quizViewModel.alertMessage),
                dismissButton: .default(Text("OK")) {
                    quizViewModel.canProceed = true
                }
            )
        }
    }
}

#Preview{
    AlertView(quizViewModel: QuizViewModel())
}

