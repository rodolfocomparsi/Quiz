
import SwiftUI

struct NameInputView: View {
    @EnvironmentObject var viewModel: QuizViewModel
    @State private var name: String = ""
    @State private var isRankPresented = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack {
                    Image("quiz")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .padding(.vertical, 80)

                TextField("Digite seu nome ou apelido", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 250)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else {
                    Button("Iniciar Quiz") {
                        if !name.isEmpty {
                            viewModel.name = name
                            viewModel.startQuiz()
                        }
                    }
                    .disabled(name.isEmpty)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }

    }
}
