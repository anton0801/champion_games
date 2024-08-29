import SwiftUI

struct ShopView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userManager: UserManager
    @State var shopManager: ShopManager!
    
    var body: some View {
        VStack {
            Text("YOU CAN BUY COINS\nADDITIONALLY")
                .font(.custom("Bungee-Regular", size: 26))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            if let shopManager = shopManager {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shopManager.products.indices, id: \.self) { productIndex in
                            let product = shopManager.products[productIndex]
                            ZStack {
                                Image("card_bg")
                                VStack {
                                    Text(shopManager.productsData[product.id]?.name ?? "")
                                        .font(.custom("Bungee-Regular", size: 26))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    Image(shopManager.productsData[product.id]?.icon ?? "")
                                    
                                    HStack {
                                        Text("\(shopManager.productsData[product.id]?.reward ?? 0)")
                                            .font(.custom("Bungee-Regular", size: 26))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                        
                                        Image("coin")
                                    }
                                }
                                
                                Button {
                                    Task {
                                        try await shopManager.purchase(product)
                                    }
                                } label: {
                                    ZStack {
                                        Image("price_bg")
                                        Text(formattedPrice(product.price))
                                            .font(.custom("Bungee-Regular", size: 18))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .offset(y: 130)
                            }
                            .frame(height: 320)
                        }
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
        .onAppear {
            shopManager = ShopManager(userManager: userManager)
        }
        .background(
            Image("shop_background")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
    
     func formattedPrice(_ price: Decimal) -> String {
         let formatter = NumberFormatter()
         formatter.numberStyle = .currency
         formatter.currencySymbol = "$"
         return formatter.string(for: price) ?? ""
     }
    
}

#Preview {
    ShopView()
        .environmentObject(UserManager())
}
