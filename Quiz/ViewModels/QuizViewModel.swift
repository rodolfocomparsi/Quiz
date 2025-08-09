
import Foundation
import SwiftUI
import RealmSwift
import Combine

final class QuizViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var isQuizStarted: Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 1
    @Published var totalQuestionsAnswered: Int = 0
    @Published var isQuizFinished: Bool = false
    @Published var selectedAnswer: String?
    @Published var isCorrectAnswer: Bool = false
    @Published var showAlert: Bool = false
    @Published var showStartView: Bool = true
    @Published var isAlertPresented: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var canProceed: Bool = false
    @Published var isLoading: Bool = false
    @Published var questions: [Question] = []
    private var cancellables: Set<AnyCancellable> = []
    private let databaseService: DatabaseService
    var apiService: APIService
    
    init(databaseService: DatabaseService = DatabaseService(), apiService: APIService = APIService()) {
        self.databaseService = databaseService
        self.apiService = apiService
    }
    
    func startQuiz() {
        isLoading = true
        score = 0
        currentQuestionIndex = 0
        totalQuestionsAnswered = 0
        isQuizFinished = false
        fetchQuestions(count: 10)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Erro ao carregar perguntas: \(error)")
                }
                self.isLoading = false
            }, receiveValue: { fetchedQuestions in
                self.questions = fetchedQuestions
                self.isQuizStarted = true
                self.showStartView = false
            })
            .store(in: &cancellables)
    }
    
    private func fetchQuestions(count: Int) -> AnyPublisher<[Question], Error> {
        Publishers.MergeMany((0..<count).map { _ in
            apiService.fetchQuestion()
        })
        .collect(count)
        .eraseToAnyPublisher()
    }
    
    func loadNextQuestion(selectedAnswer: String) {
        isLoading = true
        checkAnswer(selectedAnswer)
            .sink(receiveCompletion: { _ in
                self.isLoading = false
            }, receiveValue: { isCorrect in
                self.isCorrectAnswer = isCorrect
                if isCorrect {
                    self.score += 1
                    self.alertTitle = "Correto!"
                    self.alertMessage = "Parabéns, você acertou!"
                } else {
                    self.alertTitle = "Errado!"
                    self.alertMessage = "Tente novamente na próxima."
                }
                self.totalQuestionsAnswered += 1
                self.isAlertPresented = true
                self.canProceed = false
            })
            .store(in: &cancellables)
    }
    
    func proceedToNext() {
        isLoading = true
        if totalQuestionsAnswered >= 10 {
            isQuizFinished = true
            saveScore()
        } else {
            currentQuestionIndex += 1
            selectedAnswer = nil
            isCorrectAnswer = false
            canProceed = false
        }
        isLoading = false
    }
    
    private func checkAnswer(_ selectedAnswer: String) -> AnyPublisher<Bool, Never> {
        guard !questions.isEmpty, currentQuestionIndex < questions.count else {
            return Just(false).eraseToAnyPublisher()
        }
        let answerData = ["answer": selectedAnswer]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: answerData),
              let url = URL(string: "https://quiz-api-bwi5hjqyaq-uc.a.run.app/answer?questionId=\(questions[currentQuestionIndex].id)") else {
            return Just(false).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map { $0.result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func restartQuiz() {
        isQuizStarted = false
        name = ""
        startQuiz()
        showStartView = true
    }
    
    private func saveScore() {
        let player = Player()
        player.name = name
        player.score = score
        databaseService.savePlayer(player)
    }
}
