import SwiftUI

struct NameInputView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        VStack {
            Image(systemName: "questionmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            TextField("Digite seu nome", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Iniciar Quiz") {
                if !viewModel.name.isEmpty {
                    viewModel.isQuizStarted = true
                }
            }
            .disabled(viewModel.name.isEmpty)
            .padding()
            .background(viewModel.name.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct NameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NameInputView()
    }
}
