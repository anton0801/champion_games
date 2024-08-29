import SwiftUI

struct OnBoardingView: View {
    
    @Binding var showedTutorial: Bool
    
    var tutorials = [
        "tutorial_1",
        "tutorial_2",
        "tutorial_3",
        "tutorial_4",
        "tutorial_5",
        "tutorial_6",
        "tutorial_7",
        "tutorial_8"
    ]
    @State var currentTutorialIndex = 0 {
        didSet {
            withAnimation(.easeIn) {
                currentTutorialImage = tutorials[currentTutorialIndex]
            }
        }
    }
    @State var currentTutorialImage = "tutorial_1"
    
    var body: some View {
        VStack {
            Button {
                if currentTutorialIndex < tutorials.count - 1 {
                    currentTutorialIndex += 1
                } else {
                    UserDefaults.standard.set(true, forKey: "showed_tutorial")
                    withAnimation(.linear(duration: 0.5)) {
                        showedTutorial = true
                    }
                }
            } label: {
                Image(currentTutorialImage)
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    OnBoardingView(showedTutorial: .constant(false))
}
