import Foundation
import StoreKit

struct ProductItem {
    let name: String
    let reward: Int
    let icon: String
}

class ShopManager: ObservableObject {
    
    @Published var loading = true
    @Published var products: [Product] = []
    
    var productsData: [String: ProductItem] = [
        "com.championslots.ChampionSlots.beginner": ProductItem(name: "BEGINNER", reward: 1000, icon: "coins"),
        "com.championslots.ChampionSlots.intermediate": ProductItem(name: "INTERMEDIATE", reward: 5000, icon: "coins_inter"),
        "com.championslots.ChampionSlots.advanced": ProductItem(name: "ADVANCED", reward: 10000, icon: "coins_advanced"),
        "com.championslots.ChampionSlots.advanced2": ProductItem(name: "ADVANCED", reward: 25000, icon: "coins_advanced2")
    ]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    private var productDict: [String: String]   
    
    var userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
          
        if let plistPath = Bundle.main.path(forResource: "ShopIds", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productDict = [:]
        }
        
        updateListenerTask = listenerForTransactions()
        
        Task {
            await requestProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func requestProducts() async {
        DispatchQueue.main.async {
            self.loading = true
        }
        do {
            products = try await Product.products(for: productDict.values)
            DispatchQueue.main.async {
                self.loading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await transaction.finish()
            
            if let productID = productDict.first(where: { $0.value == product.id })?.key {
               switch productID {
               case "com.championslots.ChampionSlots.beginner":
                   userManager.credits += 1000
               case "com.championslots.ChampionSlots.intermediate":
                   userManager.credits += 5000
               case "com.championslots.ChampionSlots.advanced":
                   userManager.credits += 10000
               case "com.championslots.ChampionSlots.advanced2":
                   userManager.credits += 25000
               default:
                   break
               }
           }
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let signedType):
            return signedType
        }
    }
    
    func listenerForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                } catch {
                    // Handle errors or retry logic if necessary
                }
            }
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
