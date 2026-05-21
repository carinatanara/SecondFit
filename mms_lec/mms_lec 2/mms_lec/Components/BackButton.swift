//
//  BackButton.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 19/10/25.
//

import SwiftUI

struct BackButton: View {
    var action : () -> Void
//    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward").font(.system(size: 15)).foregroundStyle(Color.darkGreen).fontWeight(.heavy)
        }
        
        
    }
}

#Preview {
    BackButton(action: {})
}
