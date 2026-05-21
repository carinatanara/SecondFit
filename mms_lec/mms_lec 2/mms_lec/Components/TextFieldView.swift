//
//  TextFieldView.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 17/10/25.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    let placehorder: String
    var isSecuredField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            if isSecuredField {
                SecureField(placehorder, text: $text).font(.system(size: 14)).accessibilityHint(Text("Password should be at least 6 characters long"))
                    .autocorrectionDisabled().textInputAutocapitalization(.never).padding().frame(width: 330, height: 50).background(Color.cream2).cornerRadius(10)
            } else {
                TextField(placehorder, text: $text).font(.system(size: 14)).autocorrectionDisabled().textInputAutocapitalization(.never).padding().frame(width: 330, height: 50).background(Color.cream2).cornerRadius(10)
            }
            
        }
    }
}

#Preview {
    TextFieldView(text: .constant(""), placehorder: "Email")
}
