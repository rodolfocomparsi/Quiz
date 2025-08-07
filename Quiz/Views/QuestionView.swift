

import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    let question: Question
    let answerHandler: (String) -> Void
    @State private var selectedAnswer: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.thinMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
                .overlay {
                    VStack {
                        Text(question.statement)
                            .font(.headline)
                            .minimumScaleFactor(0.7)
                            .padding()
                        
                        Spacer()
                        
                        VStack {
                            ForEach(question.options, id: \.self) { option in
                                Button(action: {
                                    selectedAnswer = option
                                    if let currentAnswer = selectedAnswer {
                                        answerHandler(currentAnswer)
                                    }
                                    
                                }) {
                                    HStack {
                                        Text(option)
                                            .minimumScaleFactor(0.7)
                                            Image(systemName: quizViewModel.isCorrectAnswer ? "checkmark" : "xmark")
                                                .foregroundColor(quizViewModel.isCorrectAnswer ? .green : .red)
                                        
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button("Próxima") {
                            if quizViewModel.canProceed {
                                quizViewModel.proceedToNext()
                                selectedAnswer = nil
                            }
                        }
                        .padding()
                        .disabled(!quizViewModel.canProceed)
                        .opacity(!quizViewModel.canProceed ? 0.5 : 1.0)
                        
                    }
                }
        }
    }
}
