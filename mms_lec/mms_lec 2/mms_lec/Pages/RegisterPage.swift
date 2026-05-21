//
//  Register.swift
//  mms_lec
//
//  Created by Visitor on 01/10/25.
//

import SwiftUI
import Supabase

//class RegisterViewModel: ObservableObject {
//    func signInWithApple() {
//        
//    }
//}

struct RegisterPage: View {
    @State var username : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var wrongUsername = 0
    @State var wrongPassword = 0
    @State var showLoginScreen = false
    @State var isLoading = false
    @State var result: Result<Void, Error>?
    @State var errorMessage: String?
    @State var successMessage: String?
    
    //    @StateObject var viewModel = RegisterViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.cream.ignoresSafeArea()
                
                VStack {
                    Text("Create An Account").font(.largeTitle).fontWeight(.medium).padding(.bottom, 2)
                    HStack {
                        Text("Already have an account?")
                        Button{
                            dismiss()
                        } label: {
                            Text("Login").foregroundColor(Color.darkGreen)
                        }
                       
                        
                    }.padding(.bottom, 20)
                    
                    TextFieldView(text: $username, placehorder: "Username")
                    
                    
                    TextFieldView(text: $email, placehorder: "Email")
                    
                    TextFieldView(text: $password, placehorder: "Password", isSecuredField: true)
                    
                    if let errorMessage {
                        Text(errorMessage).foregroundColor(.red).font(.caption).padding(.top, 8)
                    }
                                    
                    if let successMessage {
                        Text(successMessage).foregroundColor(.green).font(.caption).padding(.top, 8)
                    }
                        
                    Button(action: {
                        signUpButtonTapped()
                    }){
                        if isLoading {
                            ProgressView().tint(Color.white)
                        } else {
                            Text("Continue")
                        }
                    }.foregroundColor(.white).frame(width: 330, height: 50).background(Color.lightGreen).cornerRadius(10)
                               
                    Spacer()
                        
        
                        
                }.padding(.top, 40)
            }
        }
        
    }
    
    func signUpButtonTapped() {
            Task {
                isLoading = true
                errorMessage = nil
                successMessage = nil
                defer { isLoading = false }
                
                do {
                    try await supabase.auth.signUp(
                        email: email,
                        password: password,
                        redirectTo: URL(string: "secondfit.user://login-callback")
                    )
                    result = .success(())
                    successMessage = "Account created! Check your email to verify."
                } catch {
                    result = .failure(error)
                }
                
//                do {
//                    try await supabase.auth.signUp(email: email, password: password)
//                    successMessage = "Account created! Check your email to verify."
//                    
//                    // Optionally add username to profiles table after signup
//                    // let user = try await supabase.auth.session.user
//                    // try await supabase.from("profiles").insert(["id": user.id.uuidString, "username": username]).execute()
//                    
//                } catch {
//                    errorMessage = error.localizedDescription
                }
            }
        }
        
//        func authenticateUser (username: String, email: String, password: String) {
//            if username.lowercased() == "carina" {
//                wrongUsername = 0
//                
//                if password.lowercased() == "carina123" {
//                    wrongPassword = 0
//                    showLoginScreen = true
//                } else {
//                    wrongPassword = 2
//                }
//            } else {
//                wrongUsername = 2
//            }
//        }
//    }
    
//    func signInButtonTapped() {
//        Task {
//            isLoading = true
//            defer { isLoading = false }
//            do {
//                try await supabase.auth.signInWithOTP(
//                    email: email,
//                    redirectTo: URL(string: "secondfit.user://login-callback")
//                )
//                result = .success(())
//            } catch {
//                result = .failure(error)
//            }
//        }
//    }
//}

#Preview {
    RegisterPage()
}
