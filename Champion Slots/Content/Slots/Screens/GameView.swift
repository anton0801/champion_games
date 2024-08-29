import SwiftUI
import SpriteKit

struct GameView: View {
    
    @Environment(\.presentationMode) var presMode
    var slotId: Int
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        VStack {
            if slotId == 3 {
                SpriteView(scene: SpinFortScene())
                    .ignoresSafeArea()
            } else if slotId == 2 {
                SpriteView(scene: SportsSlotsScene())
                    .ignoresSafeArea()
            } else {
                SpriteView(scene: GaloreGemsSlotScene())
                    .ignoresSafeArea()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("home")), perform: { _ in
            userManager.credits = UserDefaults.standard.integer(forKey: "credits")
            presMode.wrappedValue.dismiss()
        })
    }
}

#Preview {
    GameView(slotId: 2)
        .environmentObject(UserManager())
}
