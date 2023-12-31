import Foundation
import SwiftUI
import UIKit
import RealmSwift
import Combine

final class QuizViewModel: ObservableObject {
    @Published var name = ""
    @Published var isQuizStarted = false
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var totalQuestionsAnswered = 0
    @Published var isAnimated = false
    @Published var isQuizFinished = false
    @Published var selectedAnswer: String?
    @Published var isCorrectAnswer = false
    @Published var showAlert = false
    @Published var showStartView = true
    var questions: [Question] = []
    private var cancellables: Set<AnyCancellable> = []
    @Published var isAlertPresented = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func startQuiz() {
        score = 0
        currentQuestionIndex = 0
        totalQuestionsAnswered = 0
        isQuizFinished = false
        
        fetchQuestions(count: 10) { questions in
            self.questions = questions
            self.isQuizStarted = true
        }
    }
    
    func fetchQuestions(count: Int, completion: @escaping ([Question]) -> Void) {
        var fetchedQuestions: [Question] = []
        let group = DispatchGroup()
        
        for _ in 1...count {
            group.enter()
            fetchQuestion { result in
                defer { group.leave() }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let question):
                        fetchedQuestions.append(question)
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            fetchedQuestions.sort(by: { $0.id < $1.id })
            completion(fetchedQuestions)
        }
    }
    
    enum APIError: Error {
        case invalidURL
        case requestError(Error)
        case decodingError
    }
    
    func fetchQuestion(completion: @escaping (Result<Question, APIError>) -> Void) {
        guard let baseURL = URL(string: "https://quiz-api-bwi5hjqyaq-uc.a.run.app/question") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestError(error)))
                return
            }
            guard let responseData = data else {
                completion(.failure(.requestError(NSError(domain: "", code: 0, userInfo: nil))))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Question.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    func loadNextQuestion(selectedAnswer: String) {
        checkAnswer(selectedAnswer)
            .sink { isCorrect in
                if isCorrect {
                    self.score += 1
                    self.alertTitle = "Resposta Correta"
                    self.alertMessage = "Parabéns! Você acertou a pergunta."
                } else {
                    self.alertTitle = "Resposta Incorreta"
                    self.alertMessage = "Ops! Você errou a pergunta."
                }

                self.isAlertPresented = true

                self.totalQuestionsAnswered += 1

                if self.totalQuestionsAnswered == 10 {
                    self.isQuizFinished = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.currentQuestionIndex += 1
                    }
                }

                self.selectedAnswer = nil
            }
            .store(in: &cancellables)
    }



    func checkAnswer(_ selectedAnswer: String) -> AnyPublisher<Bool, Never> {
        let answerData = ["answer": selectedAnswer]
        let jsonData = try? JSONSerialization.data(withJSONObject: answerData)
        
        guard let baseURL = URL(string: "https://quiz-api-bwi5hjqyaq-uc.a.run.app/answer?questionId=\(questions[currentQuestionIndex].id)"),
              let jsonData = jsonData else {
            return Just(false).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                return try? JSONDecoder().decode(Response.self, from: data)
            }
            .compactMap { $0 }
            .map { $0.result }
            .replaceError(with: false)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func restartQuiz() {
        isQuizStarted = false
        name = ""
        startQuiz()
         }
    }

final class CoreDataManager {
    static let shared = CoreDataManager()

    private let realm: Realm

    private init() {
        do {
            realm = try Realm()
            print("Realm file: \(realm.configuration.fileURL?.absoluteString ?? "")")
        } catch {
            fatalError("Erro ao configurar o Realm: \(error)")
        }
    }

    func savePlayer(name: String, score: Int) {
        do {
            try realm.write {
                let player = Player()
                player.name = name
                player.score = score
                realm.add(player)
            }
        } catch {
            print("Erro ao salvar o jogador: \(error)")
        }
    }

    func fetchPlayers() -> Results<Player> {
        return realm.objects(Player.self)
    }
}
