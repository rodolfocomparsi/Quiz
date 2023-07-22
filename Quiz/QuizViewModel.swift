import Foundation

final class QuizViewModel: ObservableObject {
    @Published var playerName = ""
    @Published var isQuizStarted = false
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var totalQuestionsAnswered = 0
    @Published var isAnimated = false
    @Published var isQuizFinished = false
    @Published var selectedAnswer: String?
    @Published var isCorrectAnswer = false
    @Published var showAlert = false
    
    var questions: [Question] = []
    
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
        checkAnswer(selectedAnswer) { isCorrect in
            self.isCorrectAnswer = isCorrect
            self.showAlert = true
            
            self.totalQuestionsAnswered += 1
            if isCorrect {
                self.score += 1
            }
            if self.totalQuestionsAnswered == 10 {
                self.isQuizFinished = true
            } else {
                self.currentQuestionIndex += 1
            }
            
            self.selectedAnswer = nil
        }
    }
    
    func checkAnswer(_ selectedAnswer: String, completion: @escaping (Bool) -> Void) {
        let answerData = ["answer": selectedAnswer]
        let jsonData = try? JSONSerialization.data(withJSONObject: answerData)
        
        guard let baseURL = URL(string: "https://quiz-api-bwi5hjqyaq-uc.a.run.app/answer?questionId=\(questions[currentQuestionIndex].id)"),
              let jsonData = jsonData else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let result = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        completion(result.result)
                    }
                }
            }
        }
        .resume()
    }
    
    func restartQuiz() {
        isQuizStarted = false
        playerName = ""
        startQuiz()
    }
}
