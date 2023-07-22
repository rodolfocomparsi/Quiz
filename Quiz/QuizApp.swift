import SwiftUI
import RealmSwift

@main
struct QuizApp: SwiftUI.App {
    init() {
            do {
                let realm = try Realm()
                print("Realm file: \(realm.configuration.fileURL?.absoluteString ?? "")")
            } catch {
                print("Error configuring Realm: \(error)")
            }
        }
    var body: some Scene {
        WindowGroup {
                 NavigationView {
                     LoginView()
                 }
             }
    }
}
