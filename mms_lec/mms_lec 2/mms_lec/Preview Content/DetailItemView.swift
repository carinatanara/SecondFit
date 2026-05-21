//
//  DetailItemView.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI

struct DetailItemView: View {
    @EnvironmentObject var favoriteManager : FavoriteManager
    var product: Products
    var body: some View {
        VStack(spacing: 20) {
            Image(product.image)
                .resizable()
                .scaledToFill().clipped()
                .frame(height: 410).ignoresSafeArea(edges: .top)
            
//            Image("Cardigan2").resizable()
//                .scaledToFit().clipped()
//                            .frame(width: .infinity, height: 410).ignoresSafeArea(edges: .top)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name).fontWeight(.medium).font(.system(size: 24))
                    Text("Rp  \(product.price).000").foregroundStyle(Color.gray).font(.system(size: 16))
                    
                  
                }.frame(width: 155, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    if favoriteManager.isFavorite(product: product) {
                                        favoriteManager.removeFromFavorite(product: product)
                                    } else {
                                        favoriteManager.addToFavorite(product: product)
                                    }
                }, label: {
                    Image(systemName: favoriteManager.isFavorite(product: product) ? "heart.fill" : "heart")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.darkGreen)
                }).buttonStyle(.plain)
                
            }.padding(.horizontal, 30)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nisl quam vulputate enim ultricies maecenas sed. Sed in netus venenatis suspendisse tincidunt in metus lectus").font(.footnote).padding(.horizontal, 30)
            
            
        }
        
    }
}

#Preview {
    DetailItemView(product: productList[0])
}
