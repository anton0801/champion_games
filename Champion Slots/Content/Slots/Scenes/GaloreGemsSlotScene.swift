import SpriteKit
import SwiftUI

class GaloreGemsSlotScene: SKScene {
    
    var creditsLabel = SKLabelNode()
    var credits = UserDefaults.standard.integer(forKey: "credits") {
        didSet {
            creditsLabel.text = "\(credits)"
            UserDefaults.standard.set(credits, forKey: "credits")
        }
    }
    
    private var spinBtn: SKSpriteNode!
   
    private var slots1: GaloreBaraban!
    private var slots2: GaloreBaraban!
    private var slots3: GaloreBaraban!
    
    private var line: SKSpriteNode!
    
    private var plusBtn: SKSpriteNode!
    private var minusBtn: SKSpriteNode!
    
    private var currentBet = 500 {
        didSet {
            currentBetLabel.text = "\(currentBet)"
            if currentBet > 500 {
                minusBtn.alpha = 1
            } else {
                minusBtn.alpha = 0.6
            }
            
            if currentBet <= 5000 {
                plusBtn.alpha = 1
            } else {
                plusBtn.alpha = 0.6
            }
        }
    }
    private var currentBetLabel = SKLabelNode(text: "500")
    private var currentWin = 0 {
        didSet {
            currentWinLabel.text = "\(currentWin)"
        }
    }
    private var currentWinLabel = SKLabelNode(text: "0")
    
    let slotSymbols = [
        "slot_2_1",
        "slot_2_2",
        "slot_2_3",
        "slot_2_4",
        "slot_2_5",
        "slot_2_6"
    ]
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1200, height: 2100)
                        
        let backImage = SKSpriteNode(imageNamed: "galore_gems_bg")
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
        
        plusBtn = SKSpriteNode(imageNamed: "plus_btn")
        plusBtn.size = CGSize(width: 150, height: 140)
        plusBtn.position = CGPoint(x: size.width / 2 + 380, y: size.height / 2 - 630)
        plusBtn.name = "plus_bet"
        addChild(plusBtn)
        
        minusBtn = SKSpriteNode(imageNamed: "minus_btn")
        minusBtn.size = CGSize(width: 150, height: 140)
        minusBtn.position = CGPoint(x: size.width / 2 - 380, y: size.height / 2 - 630)
        minusBtn.name = "minus_bet"
        minusBtn.alpha = 0.6
        addChild(minusBtn)
        
        let slotsMachineBack = SKSpriteNode(imageNamed: "galore_gems_slots_bg")
        slotsMachineBack.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        slotsMachineBack.size = CGSize(width: size.width - 100, height: 500)
        addChild(slotsMachineBack)
        
        slots1 = GaloreBaraban(slotSymbols: slotSymbols, size: CGSize(width: 200, height: 430)) {

        }
        slots1.position = CGPoint(x: size.width / 2 - 280, y: size.height / 2 + 210)

        slots2 = GaloreBaraban(slotSymbols: slotSymbols, size: CGSize(width: 200, height: 430)) {
           
        }
        slots2.position = CGPoint(x: size.width / 2, y: size.height / 2 + 210)

        slots3 = GaloreBaraban(slotSymbols: slotSymbols, size: CGSize(width: 200, height: 430)) {
            self.checkWinning()
        }
        slots3.position = CGPoint(x: size.width / 2 + 280, y: size.height / 2 + 210)
      
        addChild(slots1)
        addChild(slots2)
        addChild(slots3)
        
        line = SKSpriteNode(imageNamed: "line")
        line.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)
        line.size = CGSize(width: 800, height: 20)
        animateLine()
    }
    
    private func animateLine() {
        addChild(line)
        let actionFadeOut = SKAction.fadeOut(withDuration: 0.3)
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.3)
        let seq = SKAction.sequence([actionFadeOut, actionFadeIn])
        let repeate = SKAction.repeat(seq, count: 3)
        line.run(repeate) {
            self.line.removeFromParent()
        }
    }
    
    private func spin() {
        spinBtn.alpha = 0.6
        if credits >= currentBet {
            credits -= currentBet
            slots1.startScrolling()
            slots2.startScrolling()
            slots3.startScrolling()
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
        
        if object.name == "minus_bet" {
            if minusBtn.alpha == 1 {
                currentBet -= 100
            }
        }
        
        if object.name == "plus_bet" {
            if plusBtn.alpha == 1 {
                currentBet += 100
            }
        }
    }
    
    private func checkWinning() {
        spinBtn.alpha = 1
        
        let centerItem = atPoint(CGPoint(x: size.width / 2, y: size.height / 2 + 200))
        let leftItem = atPoint(CGPoint(x: size.width / 2 - 280, y: size.height / 2 + 200))
        let rightItem = atPoint(CGPoint(x: size.width / 2 + 280, y: size.height / 2 + 200))
        
        if centerItem.name == leftItem.name && centerItem.name == rightItem.name {
            animateLine()
            currentWin = currentBet * 8
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GaloreGemsSlotScene())
            .ignoresSafeArea()
    }
}

class GaloreBaraban: SKSpriteNode {
    
    var slotSymbols: [String]
    private let cropNode: SKCropNode
    private let contentNode: SKNode
    private var currentOffset: CGFloat = 0
    var endScroll: () -> Void
    
    var reverseScroll = false
    
    init(slotSymbols: [String], size: CGSize, endScroll: @escaping () -> Void) {
        self.slotSymbols = slotSymbols
        self.cropNode = SKCropNode()
        self.contentNode = SKNode()
        self.endScroll = endScroll
        super.init(texture: nil, color: .clear, size: size)
        addSymbols()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSymbols() {
        cropNode.position = CGPoint(x: 0, y: 0)
        let maskNode = SKSpriteNode(color: .black, size: size)
        maskNode.position = CGPoint(x: 0, y: 0)
        cropNode.maskNode = maskNode
        addChild(cropNode)
        cropNode.addChild(contentNode)
        let shuffledSymbols = slotSymbols.shuffled()
        for i in 0..<slotSymbols.count * 8 {
            let symbolName = shuffledSymbols[i % 6]
            let symbol = SKSpriteNode(imageNamed: symbolName)
            symbol.size = CGSize(width: 110, height: 110)
            symbol.zPosition = 1
            symbol.name = symbolName
            symbol.position = CGPoint(x: 0, y: size.height - CGFloat(i) * 140.5)
            symbol.setScale(1.0)
            contentNode.addChild(symbol)
        }
        contentNode.run(SKAction.moveBy(x: 0, y: 140.5 * CGFloat(slotSymbols.count * 3), duration: 0.0))
    }
    
    func startScrolling() {
        if reverseScroll {
            reverseScroll = false
            let actionMove = SKAction.moveBy(x: 0, y: -(140.5 * CGFloat(Int.random(in: 4...6))), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
        } else {
            let actionMove = SKAction.moveBy(x: 0, y: 140.5 * CGFloat(Int.random(in: 4...6)), duration: 0.5)
            contentNode.run(actionMove) {
                self.endScroll()
            }
            reverseScroll = true
        }
    }
    
}
