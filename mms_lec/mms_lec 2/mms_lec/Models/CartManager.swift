//
//  CartManager.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import Combine

class CartManager: ObservableObject {
    
    @Published private(set) var items: [Products] = []
    @Published private(set) var total: Int = 0
    
    func addToCart(item: Products) {
        items.append(item)
        total += item.price
    }
    
    func removeFromCart(item: Products) {
        items = items.filter { $0.id != item.id }
        total -= item.price
    }
    
    
    
}
