import SwiftUI

struct LoadGameSlotsView: View {
    
    @State var loadingProgress = 0 {
        didSet {
            loadingProgressIndicator = "loading_\(loadingProgress / 10)0"
            if loadingProgress >= 100 {
                gameLoaded = true
            }
        }
    }
    @State var loadingProgressIndicator: String = "loading_0"
    
    @State var gameLoaded = false
    
    var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image("logo")
                
                Spacer()
                
                Image(loadingProgressIndicator)
                
                NavigationLink(destination: ContentView()
                    .navigationBarBackButtonHidden(true), isActive: $gameLoaded) {
                        
                    }
            }
            .background(
                Image("loading_back")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onReceive(timer) { _ in
                if loadingProgress < 100 {
                    withAnimation(.easeIn) {
                        loadingProgress += Int.random(in: 5...20)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadGameSlotsView()
}
