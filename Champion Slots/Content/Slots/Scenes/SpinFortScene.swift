import SpriteKit
import SwiftUI

class SpinFortScene: SKScene {
    
    var creditsLabel = SKLabelNode()
    var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            creditsLabel.text = "\(credits)"
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
    private var roulette: SKSpriteNode!
    private var determineRouletteLayout: SKSpriteNode!
    private var spinBtn: SKSpriteNode!
    
    let wheelSegments = 16
    let segmentPrizes = [
        0, 1000, 0, 5000, 0, 500, 0, 1000, 0, 500, 0, 1000, 0, 5000, 0, 500
    ]
    
    private var currentBet = 500
    private var currentBetLabel = SKLabelNode(text: "500")
    private var currentWin = 0 {
        didSet {
            currentWinLabel.text = "\(currentWin)"
        }
    }
    private var currentWinLabel = SKLabelNode(text: "0")
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1200, height: 2100)
        
        let backImage = SKSpriteNode(imageNamed: "roulette_bg")
        backImage.size = size
        backImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(backImage)
        
        let homeButton = SKSpriteNode(imageNamed: "home_btn")
        homeButton.size = CGSize(width: 160, height: 120)
        homeButton.position = CGPoint(x: 130, y: size.height - 200)
        homeButton.name = "home"
        addChild(homeButton)
        
        let creditsBack = SKSpriteNode(imageNamed: "credits_back")
        creditsBack.position = CGPoint(x: size.width - 250, y: size.height - 200)
        creditsBack.size = CGSize(width: 350, height: 120)
        addChild(creditsBack)
        
        creditsLabel = .init(text: "\(credits)")
        creditsLabel.position = CGPoint(x: size.width - 190, y: size.height - 215)
        creditsLabel.fontName = "Bungee-Regular"
        creditsLabel.fontSize = 42
        creditsLabel.fontColor = .white
        addChild(creditsLabel)
        
        createRoulette()
        
        spinBtn = SKSpriteNode(imageNamed: "spin_btn")
        spinBtn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 400)
        spinBtn.size = CGSize(width: 500, height: 200)
        spinBtn.name = "spin_btn"
        spinBtn.alpha = 1
        addChild(spinBtn)
        
        let betBg = SKSpriteNode(imageNamed: "bet")
        betBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 630)
        betBg.size = CGSize(width: 500, height: 200)
        addChild(betBg)
        
        currentBetLabel.position = CGPoint(x: size.width / 2 + 50, y: size.height / 2 - 650)
        currentBetLabel.fontName = "Bungee-Regular"
        currentBetLabel.fontSize = 62
        currentBetLabel.fontColor = .white
        addChild(currentBetLabel)
        
        let winBg = SKSpriteNode(imageNamed: "win_bg")
        winBg.position = CGPoint(x: size.width / 2, y: size.height / 2 - 870)
        winBg.size = CGSize(width: 500, height: 200)
        addChild(winBg)
        
        currentWinLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 920)
        currentWinLabel.fontName = "Bungee-Regular"
        currentWinLabel.fontSize = 62
        currentWinLabel.fontColor = .white
        addChild(currentWinLabel)
    }
    
    private func createRoulette() {
        roulette = SKSpriteNode(imageNamed: "roulette")
        roulette.position = CGPoint(x: size.width / 2, y: size.height / 2 + 250)
        roulette.size = CGSize(width: 900, height: 900)
        addChild(roulette)
        
        let rouletteIndicator = SKSpriteNode(imageNamed: "roulette_indicator")
        rouletteIndicator.position = CGPoint(x: size.width / 2, y: size.height / 2 + 600)
        rouletteIndicator.size = CGSize(width: 60, height: 52)
        addChild(rouletteIndicator)
        
        determineRouletteLayout = SKSpriteNode(color: .clear, size: roulette.size)
        determineRouletteLayout.position = roulette.position
        addChild(determineRouletteLayout)
        
        let itemAngle = 2 * .pi / CGFloat(wheelSegments)
                        
        for i in 0..<wheelSegments {
            let prize = segmentPrizes[i]
            let determineNodeItem = SKSpriteNode(color: .clear, size: CGSize(width: 700, height: 50))
            determineNodeItem.anchorPoint = CGPoint(x: 0.5, y: 1)
            determineNodeItem.position = CGPoint(x: 0, y: 0)
            determineNodeItem.zRotation = -(itemAngle * CGFloat(i) - .pi / 2)
            determineNodeItem.name = "\(prize)"
            determineRouletteLayout.addChild(determineNodeItem)
        }
    }
    
    private func spin() {
        if credits >= currentBet {
            spinBtn.alpha = 0.6
            currentWin = 0
            credits -= currentBet
            let randomSpin = CGFloat.random(in: 5...10)
            let rotateBy = randomSpin * 2 * .pi
            let rotateAction = SKAction.rotate(byAngle: rotateBy, duration: 2.0)
            rotateAction.timingMode = .linear
            roulette.run(rotateAction)
            determineRouletteLayout.run(rotateAction) {
                self.determinePrize()
            }
        }
    }
    
    func determinePrize() {
        spinBtn.alpha = 1
        let winningNode = atPoint(CGPoint(x: size.width / 2, y: size.height / 2 + 600))
        if let prizeName = winningNode.name, let prize = Int(prizeName) {
            currentWin = prize
            if prize == 0 {
                // playSound(for: "loss")
            } else {
                credits += prize
                // playSound(for: "win")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let object = atPoint(touch.location(in: self))
        
        if object.name == "home" {
            NotificationCenter.default.post(name: Notification.Name("home"), object: nil)
        }
        
        if object.name == "spin_btn" {
            if spinBtn.alpha == 1 {
                spin()
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: SpinFortScene())
            .ignoresSafeArea()
    }
}
