//
//  CategoryItemView.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import SwiftUI

struct CategoryItemView: View {
    var isSelected: Bool = true
    var title: String = "Clothes"
    var onDeselect: () -> Void = {}
    
    var body: some View {
        ZStack {
            
            if isSelected {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(Color.lightGreen).frame(height: 31)
                        
                    HStack(spacing: 6) {
                        Text(title).font(.system(size: 12)).foregroundStyle(Color.black)
                        
                        Button(action: {
                            onDeselect()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.black)
                        }.buttonStyle(.plain)
                    }.padding(.horizontal, 20)
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).stroke(Color.lightGreen, lineWidth: 1).fill(Color.cream).frame(height: 31)
                    
                    Text(title).foregroundStyle(Color.black).font(.system(size: 12)).padding(.horizontal, 24)
                }
                
            }
        }
        
    }
}

#Preview {
    CategoryItemView()
}
