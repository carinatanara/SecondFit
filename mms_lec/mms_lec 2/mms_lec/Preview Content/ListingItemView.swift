//
//  ListingItemView.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI

struct ListingItemView: View {
    @EnvironmentObject var cartManager : CartManager
    var product : Products
    
    var body: some View {
        VStack(spacing: 10) {
//            Rectangle().frame(width: 155, height: 164).clipShape(RoundedRectangle(cornerRadius: 10))
            
            Image(product.image).resizable().aspectRatio(contentMode: .fill).frame(width: 155, height: 164).clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name).fontWeight(.medium)
                Text("Rp\(product.price).000").foregroundStyle(Color.gray)
                
              
            }.frame(width: 155, alignment: .leading)
            
        }.font(.footnote)
    }
}

#Preview {
    ListingItemView(product: productList[0]).environmentObject(CartManager())
}
