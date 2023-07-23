import SwiftUI
import RealmSwift

@main
struct QuizApp: SwiftUI.App {
    @StateObject private var quizViewModel = QuizViewModel()
       @State private var startQuiz: Bool = false // Adicione @State aqui

       var body: some Scene {
           WindowGroup {
               NavigationView {
                   LoginView(startQuiz: $startQuiz) // Passe startQuiz como @Binding para o LoginView
               }
               .environmentObject(quizViewModel)
               .onChange(of: quizViewModel.isQuizStarted) { isStarted in
                   if isStarted {
                       startQuiz = true // Atualize startQuiz quando o quiz for iniciado no ViewModel
                   }
               }
               .navigationViewStyle(StackNavigationViewStyle())
           }
       }
   }
