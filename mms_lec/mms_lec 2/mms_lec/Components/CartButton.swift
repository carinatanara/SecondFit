//
//  CartButton.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import SwiftUI

struct CartButton: View {
    var numberOfProducts: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "cart.fill").foregroundStyle(Color.darkGreen).padding(5).buttonStyle(.plain)
            
            if numberOfProducts > 0 {
                Text("\(numberOfProducts)").frame(width: 15, height: 15).background(Color.black).cornerRadius(50).font(.system(size: 8)).foregroundStyle(Color.cream)
            }
        }
    }
}

#Preview {
    CartButton(numberOfProducts: 2)
}
