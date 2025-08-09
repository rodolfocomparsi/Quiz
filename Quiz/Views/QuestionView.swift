

import SwiftUI

struct QuestionView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    let question: Question
    let answerHandler: (String) -> Void
    @State private var selectedAnswer: String?
    
    var body: some View {
        VStack (spacing: 60){
            VStack {
                Text("\(quizViewModel.totalQuestionsAnswered)/10")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical)
                
                Text(question.statement)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding([.horizontal, .bottom])
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 319, height: 128)
            .background(Color("DynamoxColor"))
            .cornerRadius(8)
            
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(question.options, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                            if let currentAnswer = selectedAnswer {
                                answerHandler(currentAnswer)
                            }
                        }) {
                            Text(option)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(selectedAnswer == option ? Color("DynamoxGreen") : Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedAnswer == option ? Color("DynamoxGreenStrong") : Color.black, lineWidth: 2)
                                )
                                .cornerRadius(8)
                        }
                        
                    }
                }

            }
            .frame(maxHeight: .infinity - 128 - 32)
            
        }
        .frame(maxWidth: 319, maxHeight: .infinity - 544)
        .overlay(alignment: .center) {
            if quizViewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("DynamoxLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
            }
        }
        .onChange(of: quizViewModel.isCorrectAnswer) { newValue in
            if newValue {
                if !quizViewModel.isCorrectAnswer {
                    selectedAnswer = nil
                }
            }
        }
        
        Spacer()
    }
}
