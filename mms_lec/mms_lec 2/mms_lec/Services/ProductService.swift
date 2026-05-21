//
//  ProductService.swift
//  mms_lec
//
//  Created by glentino dureno lomo on 30/11/25.
//

import Foundation
import Combine

struct ProductListingsResponse: Codable {
    let count: Int
    let results: [ProductListing]
}

struct ProductListing: Codable {
    let listing_id: Int
    let title: String
    let description: String?
    let price: ProductPrice
    let shop_id: Int
    let user_id: Int
    let url: String
    let quantity: Int
    let state: String
    let tags: [String]?
    let images: [ProductImage]?
}

struct ProductPrice: Codable {
    let amount: Int
    let divisor: Int
    let currency_code: String
    
    var displayPrice: Double {
        return Double(amount) / Double(divisor)
    }
}

struct ProductImage: Codable {
    let url_75x75: String?
    let url_170x135: String?
    let url_570xN: String?
    let url_fullxfull: String?
}

class ProductService: ObservableObject {
    @Published var products: [Products] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = "kxsq6wsls4xmm97ydergbrcc"
    private let baseURL = "https://api.etsy.com/v3/application"
    
    func fetchShopListings(shopId: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)/shops/\(shopId)/listings/active") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            let productResponse = try JSONDecoder().decode(ProductListingsResponse.self, from: data)
            let mappedProducts = productResponse.results.map { mapProductListingToProduct($0) }
            
            await MainActor.run {
                self.products = mappedProducts
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Error fetching listings: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func searchListings(query: String, limit: Int = 25) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        var components = URLComponents(string: "\(baseURL)/listings/active")
        components?.queryItems = [
            URLQueryItem(name: "keywords", value: query),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = components?.url else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            let productResponse = try JSONDecoder().decode(ProductListingsResponse.self, from: data)
            let mappedProducts = productResponse.results.map { mapProductListingToProduct($0) }
            
            await MainActor.run {
                self.products = mappedProducts
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Error searching listings: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    private func mapProductListingToProduct(_ listing: ProductListing) -> Products {
        // Get the image URL (prioritize larger images)
        let imageUrl = listing.images?.first?.url_570xN
            ?? listing.images?.first?.url_170x135
            ?? listing.images?.first?.url_75x75
            ?? ""
        
        // Try to map tags to categories
        let categories = mapTagsToCategories(listing.tags ?? [])
        
        return Products(
            name: listing.title,
            image: imageUrl,
            supplier: "Shop ID: \(listing.shop_id)",
            description: listing.description ?? "",
            price: Int(listing.price.displayPrice),
            categories: categories
        )
    }
    
    /// Attempts to map Etsy tags to your Categories enum
    private func mapTagsToCategories(_ tags: [String]) -> [Categories] {
        var categories: [Categories] = []
        
        for tag in tags {
            let lowercasedTag = tag.lowercased()
            
            if lowercasedTag.contains("shirt") {
                categories.append(.Shirt)
            } else if lowercasedTag.contains("top") {
                categories.append(.Top)
            } else if lowercasedTag.contains("jacket") || lowercasedTag.contains("cardigan") {
                categories.append(.Jacket)
            } else if lowercasedTag.contains("bottom") || lowercasedTag.contains("pants") {
                categories.append(.Bottom)
            } else if lowercasedTag.contains("shorts") {
                categories.append(.Shorts)
            } else if lowercasedTag.contains("tank") {
                categories.append(.Tanktop)
            }
        }
        
        return categories.isEmpty ? [.Top] : Array(Set(categories))
    }
}

enum NetworkError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        }
    }
}
