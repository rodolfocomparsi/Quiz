import Foundation
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var isQuizStarted: Bool = false
}
