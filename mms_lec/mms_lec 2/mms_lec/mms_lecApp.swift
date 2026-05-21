//
//  mms_lecApp.swift
//  mms_lec
//
//  Created by Visitor on 01/10/25.
//

import SwiftUI
import Supabase

@main
struct mms_lecApp: App {
    @StateObject var cartManager = CartManager()
    @StateObject var favoriteManager = FavoriteManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environmentObject(cartManager).environmentObject(favoriteManager).onOpenURL { url in
                supabase.auth.handle(url)
            }
        }
    }
}
