import Foundation

class UserManager: ObservableObject {
    
    @Published var credits: Int = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
}
