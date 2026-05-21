//
//  MainTabView.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI
import Supabase

struct MainTabView: View {
    @EnvironmentObject var cartManager: CartManager
        @EnvironmentObject var favoriteManager: FavoriteManager
        @State var isAuthenticated = false
        
        var body: some View {
            Group {
                if isAuthenticated {
                    TabView {
                        NavigationView {
                            HomePage()
                        }
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        
                        NavigationView {
                            FavoritePage()
                        }
                        .tabItem {
                            Image(systemName: "heart")
                            Text("Favorite")
                        }
                        
                        NavigationView {
                            ProfilePage()
                        }
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = false
                        
                        let appearance = UITabBarAppearance()
                        appearance.configureWithTransparentBackground()
                        appearance.backgroundColor = UIColor(Color.cream)
                        
                        UITabBar.appearance().standardAppearance = appearance
                        UITabBar.appearance().scrollEdgeAppearance = appearance
                    }
                } else {
                    NavigationStack {
                        LoginPage()
                    }
                }
            }
            .task {
                for await state in supabase.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        }
    }

#Preview {
    MainTabView().environmentObject(CartManager()).environmentObject(FavoriteManager())
}
