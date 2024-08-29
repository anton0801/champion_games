import SwiftUI

struct ContentView: View {
    
    @State var volumeMusic = UserDefaults.standard.bool(forKey: "volume_music") {
        didSet {
            UserDefaults.standard.set(volumeMusic, forKey: "volume_music")
        }
    }
    
    @State var volumeSounds = UserDefaults.standard.bool(forKey: "volume_sounds") {
        didSet {
            UserDefaults.standard.set(volumeSounds, forKey: "volume_sounds")
        }
    }
    
    @State var showedTutorial = UserDefaults.standard.bool(forKey: "showed_tutorial")
    
    @StateObject var userManager: UserManager = UserManager()
    
    var body: some View {
        if !showedTutorial {
            OnBoardingView(showedTutorial: $showedTutorial)
        } else {
            NavigationView {
                VStack {
                    HStack {
                        Button {
                            withAnimation(.easeInOut) {
                                volumeMusic = !volumeMusic
                            }
                        } label: {
                            if volumeMusic {
                                Image("volume_music_on")
                            } else {
                                Image("volume_music_on")
                                    .opacity(0.6)
                            }
                        }
                        Spacer()
                        Button {
                            withAnimation(.easeInOut) {
                                volumeSounds = !volumeSounds
                            }
                        } label: {
                            if volumeSounds {
                                Image("volume_sounds_on")
                            } else {
                                Image("volume_sounds_on")
                                    .opacity(0.6)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    ZStack {
                        Image("credits_back")
                        Text("0")
                            .font(.custom("Bungee-Regular", size: 24))
                            .foregroundColor(.white)
                            .offset(x: 25)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SlotsListView()
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                    }
                    NavigationLink(destination: ShopView()
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("shop_btn")
                    }
                    NavigationLink(destination: DailyBonusView()
                        .environmentObject(userManager)
                        .navigationBarBackButtonHidden(true)) {
                        Image("bonus_btn")
                    }
                }
                .background(
                    Image("main_background")
                        .resizable()
                        .frame(minWidth: UIScreen.main.bounds.width,
                               minHeight: UIScreen.main.bounds.height)
                        .ignoresSafeArea()
                )
                .onChange(of: showedTutorial) { _ in
                    UserDefaults.standard.set(true, forKey: "showed_tutorial")
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    ContentView()
}
