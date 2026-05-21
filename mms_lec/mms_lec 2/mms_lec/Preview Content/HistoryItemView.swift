//
//  HistoryItemView.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 17/10/25.
//

import SwiftUI

struct HistoryItemView: View {
    var searchTerm: String
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(searchTerm).foregroundStyle(Color.black).font(.system(size: 12)).padding(.horizontal, 24).padding(.vertical, 8).background(RoundedRectangle(cornerRadius: 10).fill(Color.lightGray))
        }
    }
}

#Preview {
    HistoryItemView(searchTerm: "", onTap: {})
}
