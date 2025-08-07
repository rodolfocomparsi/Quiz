
import Foundation
import Combine
import SwiftUI
import RealmSwift

class QuizViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var isQuizStarted: Bool = false
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var isLoading: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private let apiService = APIService()
    private let realm = try! Realm()
    
    func startQuiz() {
        isLoading = true
        let questionCount = 2
        Publishers.MergeMany((0..<questionCount).map { _ in
            apiService.fetchQuestion()
        })
        .collect(questionCount)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("Erro ao carregar perguntas: \(error)")
            }
            self.isLoading = false
        }, receiveValue: { fetchedQuestions in
            self.questions = fetchedQuestions
            self.isQuizStarted = true
        })
        .store(in: &cancellables)
    }
    
    func checkAnswer(_ answer: String) -> Bool {
        guard !questions.isEmpty, currentQuestionIndex < questions.count else { return false }
        let correct = questions[currentQuestionIndex].correctAnswer == answer
        if correct { score += 1 }
        currentQuestionIndex += 1
        return correct
    }
    
    var isQuizFinished: Bool {
        currentQuestionIndex >= questions.count
    }
    
    func saveScore() {
        let player = Player()
        player.name = name
        player.score = score
        try! realm.write {
            realm.add(player)
        }
    }
}

class Player: Object {
    @Persisted var name: String = ""
    @Persisted var score: Int = 0
}
