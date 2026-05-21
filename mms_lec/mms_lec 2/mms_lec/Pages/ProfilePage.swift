//
//  ProfilePage.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import SwiftUI
import Supabase
import PhotosUI

struct ProfilePage: View {

    @State var isLoading = false
    @State private var fullName = "Username"
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var profileImage: Image = Image(systemName: "person.circle.fill")
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.cream.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        // Profile picture
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .foregroundColor(Color(.systemGray4)) .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            
                    
                        // Full name
                        Text(fullName)
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        //Edit
                        VStack(spacing: 0) {
                            PhotosPicker(
                                selection: $selectedPhotoItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                HStack(spacing: 15) {
                                    Image(systemName: "person")
                                        .font(.title3)
                                        .frame(width: 30)
                                    
                                    Text("Edit Profile Picture")
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .foregroundColor(.black)
                            }
                            
                            Divider().padding(.horizontal)
                            
                            ProfileNavigationLink(
                                icon: "pencil",
                                title: "Edit Username",
                                destination: EditUsernameView(fullName: $fullName)
                            )
                        }
                        .background(Color.lightGray)
                        .cornerRadius(10)
                        .padding(.horizontal, 45)
                        
                        //About us & Sign out
                        VStack(spacing: 0) {
                            ProfileNavigationLink(
                                icon: "person.2",
                                title: "About Us",
                                destination: AboutUsView()
                            )
                            
                            Divider().padding(.horizontal)
                            
                            // Sign Out Button
                            ProfileButton(
                                icon: "arrow.left.to.line",
                                title: "Sign Out",
                                color: .red
                            ) {
//                                Task {
//                                    await signOut()
//                                }
                            }
                        }
                        .background(Color.lightGray)
                        .cornerRadius(15)
                        .padding(.horizontal, 45)
                        
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .onChange(of: selectedPhotoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            selectedImageData = data
                            if let uiImage = UIImage(data: data) {
                                profileImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
//    func signOut() async {
//        do {
//            try await supabase.auth.signOut()
//            print("User signed out successfully.")
//            
//        } catch {
//            print("Error signing out: %@", error.localizedDescription)
//        }
//    }
}

struct ProfileNavigationLink<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .foregroundColor(.black)
        }
    }
}

struct ProfileButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                
                Spacer()
            }
            .padding()
            .foregroundColor(color)
        }
    }
}

struct EditUsernameView: View {
    @Binding var fullName: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section(header: Text("Edit Name")) {
                TextField("Full Name", text: $fullName)
            }
            
            Button("Save") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Username")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutUsView: View {
    var body: some View {
        Form {
            Section(header: Text("Our Team")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("The Creators of SecondFit!")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    //carcar
                    HStack(spacing: 15) {
                        Image("carcar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text("Carina Amrah Tanara")
                                .font(.headline)
                        }
                    }
                    
                    //marcy
                    HStack(spacing: 15) {
                        Image("marcy")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text("Marcella")
                                .font(.headline)
                        }
                    }
                }
                .padding(.vertical, 10)
            }
            
            Section(header: Text("Our Mission")) {
                Text("Our mission is to bring ease of access towards thrifted clothing for those who love fashion and prefer the affordable choices.")
                    .padding(.vertical, 5)
            }
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfilePage()
}
