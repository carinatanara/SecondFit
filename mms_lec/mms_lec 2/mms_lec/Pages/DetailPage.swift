//
//  DetailPage.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import SwiftUI

struct DetailPage: View {
    var product: Products
    var body: some View {
        ZStack {
            Color.cream
                .ignoresSafeArea(.all)
            VStack {
                ScrollView {
                    DetailItemView(product: product)
                }.ignoresSafeArea(edges: .top)
                
                Button(action: {}, label: {
                    Text("Buy").foregroundStyle(Color.cream).fontWeight(.bold).frame(width: 340, height: 58)
                    
                }).background(Color.lightGreen).cornerRadius(10).padding(.bottom, 30).buttonStyle(.plain)
            }
            
    
        }
    }
}

#Preview {
    DetailPage(product: productList[0])
}
