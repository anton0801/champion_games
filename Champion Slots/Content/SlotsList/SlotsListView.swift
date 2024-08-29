import SwiftUI

struct SlotsListView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Choose any type\nof slot to play")
                    .font(.custom("Bungee-Regular", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Spacer()
                
                TabView {
                    NavigationLink(destination: GameView(slotId: 1)
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                            Image("galore_gems")
                        }
                    NavigationLink(destination: GameView(slotId: 2)
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                            Image("sports_slot")
                        }
                    NavigationLink(destination: GameView(slotId: 3)
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                            Image("spin_fort")
                        }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                HStack {
                   Button {
                       presMode.wrappedValue.dismiss()
                   } label: {
                       Image("home_btn")
                   }
                   Spacer()
               }
               .padding()
            }
            .background(
                Image("main_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SlotsListView()
        .environmentObject(UserManager())
}
