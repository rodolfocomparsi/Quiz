
import Foundation
import Combine

class APIService {
    func fetchQuestion() -> AnyPublisher<Question, Error> {
        guard let url = URL(string: "https://quiz-api-bwi5hjqyaq-uc.a.run.app/question") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Question.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
