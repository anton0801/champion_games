import SwiftUI

struct DailyBonusView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userManager: UserManager
    @StateObject var dailyBonusManager = DailyBonusManager()
    
    var body: some View {
        VStack {
            Text("YOU CAN BUY COINS\nADDITIONALLY")
                .font(.custom("Bungee-Regular", size: 26))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(dailyBonusManager.rewards, id: \.id) { dailyBonus in
                        ZStack {
                            Image("card_bg")
                            VStack {
                                Text(dailyBonus.name)
                                    .font(.custom("Bungee-Regular", size: 26))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Image(dailyBonus.icon)
                                
                                HStack {
                                    Text("\(dailyBonus.reward)")
                                        .font(.custom("Bungee-Regular", size: 26))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    Image("coin")
                                }
                            }
                            
                            if dailyBonusManager.canClaimReward(forDay: dailyBonus.day) {
                                Button {
                                    if dailyBonusManager.claimReward(forDay: dailyBonus.day) {
                                        userManager.credits += dailyBonus.reward
                                    }
                                } label: {
                                    ZStack {
                                        Image("price_bg")
                                        Text("GET")
                                            .font(.custom("Bungee-Regular", size: 18))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .offset(y: 130)
                            } else {
                                
                            }
                        }
                        .frame(height: 320)
                        .padding(.horizontal)
                    }
                }
            }
            
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
            Image("bonus_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    DailyBonusView()
}
