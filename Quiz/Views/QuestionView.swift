

import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    let question: Question
    let answerHandler: (String) -> Void
    @State private var selectedAnswer: String?
    @State private var isSelectionLocked: Bool = false
    
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
                                    if !isSelectionLocked && selectedAnswer == nil {
                                        selectedAnswer = option
                                        if let currentAnswer = selectedAnswer {
                                            answerHandler(currentAnswer)
                                            isSelectionLocked = true
                                        }
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                            .minimumScaleFactor(0.7)
                                        if selectedAnswer == option {
                                            Image(systemName: quizViewModel.isCorrectAnswer ? "checkmark" : "xmark")
                                                .foregroundColor(quizViewModel.isCorrectAnswer ? .green : .red)
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(selectedAnswer == option ? Color.blue : Color.gray)
                                    .cornerRadius(8)
                                    .disabled(isSelectionLocked && selectedAnswer != option)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if quizViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                                .padding()
                        } else {
                            Button("Próxima") {
                                if quizViewModel.canProceed {
                                    quizViewModel.proceedToNext()
                                    isSelectionLocked = false
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
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Spacer(minLength: 30)
                    Image("quiz")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Spacer()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Voltar") {
                    quizViewModel.showStartView = true
                    quizViewModel.isQuizStarted = false
                    isSelectionLocked = false
                    selectedAnswer = nil
                }
            }
        }
        .onChange(of: quizViewModel.isCorrectAnswer) { newValue in
            if newValue {
                if !quizViewModel.isCorrectAnswer {
                    selectedAnswer = nil
                }
            }
        }
    }
}
