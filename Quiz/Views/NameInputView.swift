
import SwiftUI

struct NameInputView: View {
    @StateObject private var viewModel = QuizViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                TextField("Digite seu nome", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                NavigationLink(destination: viewModel.isQuizStarted ? AnyView(QuestionView(viewModel: viewModel, question: viewModel.questions.isEmpty ? Question(id: "", statement: "", options: [], correctAnswer: nil) : viewModel.questions[viewModel.currentQuestionIndex])) : AnyView(EmptyView()), isActive: $viewModel.isQuizStarted) {
                    Button("Iniciar Quiz") {
                        if !viewModel.name.isEmpty {
                            viewModel.startQuiz()
                        }
                    }
                    .disabled(viewModel.name.isEmpty)
                    .padding()
                    .background(viewModel.name.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}

struct NameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NameInputView()
    }
}
