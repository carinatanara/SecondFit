//
//  FavoritePage.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI

struct FavoritePage: View {
    @EnvironmentObject var cartManager : CartManager
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    var body: some View {
        
            NavigationStack {
                ZStack {
                    Color.cream
                        .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0){
                        HStack {
                            Text("Favorite").fontWeight(.medium).font(.system(size: 24))
                            Spacer()
                        }.padding(.horizontal, 30)
                    }.frame(alignment: .leading)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 30),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(favoriteManager.favoriteProducts) { product in
                            NavigationLink(destination: DetailPage(product: product)) {
                                ListingItemView(product: product)
                            }
                        }
                    }.padding(.horizontal, 30)
                    
                }
            }
            
        }
    }
}

#Preview {
    FavoritePage().environmentObject(CartManager()).environmentObject(FavoriteManager())
}
