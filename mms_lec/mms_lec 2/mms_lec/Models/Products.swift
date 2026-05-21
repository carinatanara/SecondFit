//
//  Products.swift
//  mms_lec
//
//  Created by Visitor on 10/10/25.
//

import Foundation

struct Products: Identifiable {
    var id = UUID()
    var name : String
    var image : String
    var supplier : String
    var description : String
    var price : Int
    var categories : [Categories]
}

enum Categories: String, CaseIterable {
    case Shirt = "Shirt"
    case Top = "Top"
    case Jacket = "Jacket"
    case Bottom = "Bottom"
    case Shorts = "Shorts"
    case Tanktop = "Tanktop"
}

var productList = [
    Products(name: "Cardigan", image: "Cardigan", supplier: "Carina", description: "", price: 150, categories: [.Top, .Jacket]),
    Products(name: "Cardigan", image: "Cardigan2", supplier: "Marcella", description: "", price: 150, categories: [.Jacket]),
    Products(name: "Jorts", image: "Cardigan", supplier: "Delbert", description: "", price: 150, categories: [.Shorts, .Bottom]),
    Products(name: "Shirt", image: "Cardigan", supplier: "Marcy", description: "", price: 150, categories: [.Top])
]
