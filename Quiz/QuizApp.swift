
import SwiftUI

@main
struct QuizApp: SwiftUI.App {
    @StateObject private var quizViewModel = QuizViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if quizViewModel.showStartView {
                    NameInputView()
                } else if quizViewModel.isQuizStarted {
                    AlertView(quizViewModel: quizViewModel)
                }
            }
            .environmentObject(quizViewModel)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
