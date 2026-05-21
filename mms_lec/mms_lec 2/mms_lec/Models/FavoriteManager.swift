//
//  FavoriteManager.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 18/10/25.
//

import Combine
import Foundation

class FavoriteManager: ObservableObject {
    @Published var favoriteProducts: [Products] = []
    
    func addToFavorite(product: Products) {
        if !favoriteProducts.contains(where: { $0.id == product.id }) {
            favoriteProducts.append(product)
        }
    }
    
    func removeFromFavorite(product: Products) {
        favoriteProducts.removeAll { $0.id == product.id }
    }
    
    func isFavorite(product: Products) -> Bool {
        favoriteProducts.contains(where: { $0.id == product.id })
    }
}

