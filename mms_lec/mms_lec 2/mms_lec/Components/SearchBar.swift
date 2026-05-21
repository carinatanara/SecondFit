//
//  SearchBar.swift
//  mms_lec
//
//  Created by Visitor on 07/10/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var search : String
    @Binding var searchHistory: [String]
    var onSearch: () -> Void
    
    var body: some View {
        
        ZStack {
            Rectangle().foregroundStyle(Color.cream2).frame(height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
            HStack {
                TextField("Search", text: $search).foregroundStyle(Color.font).font(.system(size: 14)).fontWeight(.medium)
                
                Spacer()
                
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass").foregroundStyle(Color.font).font(.system(size: 15))
                }
                
                
            }.padding(.horizontal, 25)
        
        
        }
    }
}

#Preview {
    SearchBar(search: .constant(""), searchHistory: .constant([]), onSearch: {})
}
