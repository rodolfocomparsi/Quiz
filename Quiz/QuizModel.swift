import Foundation

struct Question: Codable, Equatable {
    let id: String
    let statement: String
    let options: [String]
}

struct Response: Codable {
    let result: Bool
}

final class QuizManager: ObservableObject {
    @Published var questions: [Question] = []

    func fetchQuestion() {
        fetchQuestion { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let question):
                    self.questions.append(question)
                case .failure(let error):
                    // Handle error if needed
                    print(error)
                }
            }
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
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Adjust key decoding strategy if needed
                let result = try decoder.decode(Question.self, from: responseData)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
