
import SwiftUI

struct QuestionView: View {
    let question: Question
    let answerHandler: (String) -> Void
    
    @State private var selectedAnswer: String?
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.thinMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
                .overlay {
                    VStack {
                        VStack{
                            Text(question.statement)
                                .font(.headline)
                                .padding()
                        }
                        Spacer()
                        VStack{
                            ForEach(question.options, id: \.self) { option in
                                Button(action: {
                                    selectedAnswer = option
                                }) {
                                    HStack {
                                        Text(option)
                                        if selectedAnswer == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(selectedAnswer == option ? Color.blue : Color.gray)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        Spacer()
                        VStack{
                            Button("Responder") {
                                if let selectedAnswer = selectedAnswer {
                                    answerHandler(selectedAnswer)
                                    self.selectedAnswer = nil
                                }
                                
                                
                            }
                            .padding()
                            .disabled(selectedAnswer == nil)
                            .opacity(selectedAnswer == nil ? 0.5 : 1.0)
                        }
                    }
                }
        }.navigationTitle(Text("Quiz"))
            .background(Color(.systemGray6))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Spacer()
                        Image("quiz")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70, alignment: .center)
                        
                        Spacer()
                    }
                }
            }
    }
}
