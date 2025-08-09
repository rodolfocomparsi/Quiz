
import SwiftUI

struct NameInputView: View {
    @EnvironmentObject var viewModel: QuizViewModel
    @State private var name: String = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image("DynamoxLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                
                Text("Dynamox Quiz")
                    .font(.system(size: 24).bold())
                    .foregroundColor(Color("DynamoxColor"))
            }
            .frame(width: 250, height: 56, alignment: .top)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Digite seu nome:")
                
                TextField("Nome", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(Color("DynamoxColor"))
                    .frame(maxWidth: 299, maxHeight: 48)
                
                
                Button(action: {
                    if !name.isEmpty {
                        viewModel.name = name
                        viewModel.startQuiz()
                    }
                }, label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .foregroundColor(.white)
                    } else {
                        Text("Começar")
                            .foregroundColor(.white)
                    }
                })
                .disabled(name.isEmpty)
                .frame(maxWidth: 299, maxHeight: 48)
                .background(Color("DynamoxColor"))
                .cornerRadius(8)
                
            }
            .frame(width: 300, height: 150, alignment: .center)
            .padding(.top, 200)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
