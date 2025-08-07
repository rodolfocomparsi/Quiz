import Foundation
    import SwiftUI

    class QuizViewModel: ObservableObject {
        @Published var name: String = ""
        @Published var isQuizStarted: Bool = false
        @Published var questions: [Question] = []
        @Published var currentQuestionIndex: Int = 0
        @Published var score: Int = 0

        func startQuiz() {
          
       
        }

        func checkAnswer(_ answer: String) -> Bool {
            guard !questions.isEmpty, currentQuestionIndex < questions.count else { return false }
            let correct = questions[currentQuestionIndex].correctAnswer == answer
            if correct { score += 1 }
            currentQuestionIndex += 1
            return correct
        }
    }
