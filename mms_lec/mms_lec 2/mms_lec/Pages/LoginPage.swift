//
//  HomePage.swift
//  mms_lec
//
//  Created by Visitor on 03/10/25.
//

import SwiftUI
import Supabase

struct LoginPage: View {
    @State var email : String = ""
    @State var password : String = ""
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State var isLoading = false
    @State var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color.cream.ignoresSafeArea()
        
            VStack {
                Text("Welcome Back to \nSecondFit ").font(.largeTitle).fontWeight(.medium).multilineTextAlignment(.center).padding(.bottom, 30)
                    
                TextFieldView(text: $email, placehorder: "Email")
                    
                TextFieldView(text: $password, placehorder: "Password", isSecuredField: true)
                    
                Button(action: {
                        authenticateUser(email: email, password: password)
                }, label: {
                    Text("Log in")
                }).foregroundColor(.white).frame(width: 330, height: 50).background(Color.lightGreen).cornerRadius(10).buttonStyle(.plain)
                    
                HStack {
                    Text("New to SecondFit?")
                    NavigationLink(destination:
                                    RegisterPage().navigationBarBackButtonHidden()){
                        Text("Register").foregroundColor(Color.darkGreen)
                    }
//                        Button(action: {}, label: {
//                            Text("Register").foregroundColor(Color.darkGreen)
//                        })
                }.padding(.top, 20)
                    
            }
        }
        
    }
    
    func authenticateUser (email: String, password: String) {
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                        
                let result = try await supabase.auth.signIn(
                    email: email,
                    password: password
                )
                        
                    
                if result.user != nil {
                            // Authentication succeeded
                    showLoginScreen = true
                } else {
                            
                    errorMessage = "Login failed, please check your credentials."
                }
                        
            } catch {
                   
                print("Login Error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginPage()
}

