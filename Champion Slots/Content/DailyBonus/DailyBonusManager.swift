import Foundation

struct DailyReward: Identifiable {
    let id = UUID()
    let name: String
    let reward: Int
    let icon: String
    let day: Int
}
class DailyBonusManager: ObservableObject {
    @Published var currentDay: Int {
        didSet {
            UserDefaults.standard.set(currentDay, forKey: "currentDay")
        }
    }
    
    @Published var rewards: [DailyReward] = []
    
    @Published var claimedRewards: Set<Int> {
        didSet {
            let claimedArray = Array(claimedRewards)
            UserDefaults.standard.set(claimedArray, forKey: "claimedRewards")
        }
    }
    
    init() {
        self.currentDay = UserDefaults.standard.integer(forKey: "currentDay")
        
        if let savedClaimedRewards = UserDefaults.standard.array(forKey: "claimedRewards") as? [Int] {
            self.claimedRewards = Set(savedClaimedRewards)
        } else {
            self.claimedRewards = []
        }
        
        self.rewards = generateDailyRewards()
        
        if self.currentDay == 0 {
            self.currentDay = 1
        }
    }
    
    // Method to generate daily rewards (example setup)
    func generateDailyRewards() -> [DailyReward] {
        return [
            DailyReward(name: "Day 1", reward: 1000, icon: "coins", day: 1),
            DailyReward(name: "Day 2", reward: 2000, icon: "coins", day: 2),
            DailyReward(name: "Day 3", reward: 3000, icon: "coins_inter", day: 3),
            DailyReward(name: "Day 4", reward: 5000, icon: "coins_advanced", day: 4),
            DailyReward(name: "Day 5", reward: 8000, icon: "coins_advanced2", day: 5),
            DailyReward(name: "Day 6", reward: 12000, icon: "coins_advanced2", day: 6),
            DailyReward(name: "Day 7", reward: 15000, icon: "coins_advanced2", day: 7)
        ]
    }
    
    // Method to check if a reward can be claimed for a given day
    func canClaimReward(forDay day: Int) -> Bool {
        return day <= currentDay && !claimedRewards.contains(day)
    }
    
    // Method to claim a reward
    func claimReward(forDay day: Int) -> Bool {
        guard canClaimReward(forDay: day) else {
            return false
        }
        
        claimedRewards.insert(day)
        let reward = rewards[day - 1]
        // Here you would add the reward to the user's account, e.g., userManager.credits += reward.reward
        print("Claimed \(reward.name) with \(reward.reward) coins!")
        
        return true
    }
    
    // Method to progress to the next day
    func progressToNextDay() {
        if currentDay < rewards.count {
            currentDay += 1
        }
    }
    
    // Method to reset the daily rewards (e.g., after a week)
    func resetDailyRewards() {
        currentDay = 1
        claimedRewards.removeAll()
        UserDefaults.standard.set(currentDay, forKey: "currentDay")
        UserDefaults.standard.removeObject(forKey: "claimedRewards")
    }
}
