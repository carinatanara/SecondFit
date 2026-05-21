//
//  SearchPage.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI
import WrappingHStack

struct SearchPage: View {
    @Binding var showSearchPage : Bool
    var animation: Namespace.ID
    @ObservedObject var productService : ProductService
    
    @State private var searchTerm = ""
    @State private var searchHistory: [String] = []
    @State private var selectedCategory: Categories? = nil
    @FocusState private var isSearchFocused: Bool
    @Environment(\.dismiss) var dismiss
    private var categories = Categories.allCases
        
    var filteredProducts: [Products] {
        let products = productService.products
                
        if let selected = selectedCategory {
            return products.filter { $0.categories.contains(selected) }
        }
        
        return products
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.cream.ignoresSafeArea(.all)
            VStack() {
                HStack {
                    BackButton(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showSearchPage = false
                        }
                    })
                    
                    SearchBar(search: $searchTerm, searchHistory: $searchHistory, onSearch: performSearch)
                        .focused($isSearchFocused)
                        .padding(.leading, 5)
                }.matchedGeometryEffect(id: "searchBar", in: animation)
                
                // Category Filter (show when there are results)
                if !productService.products.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryItemView(
                                    isSelected: selectedCategory == category,
                                    title: category.rawValue,
                                    onDeselect: {
                                        selectedCategory = nil
                                    }
                                ).onTapGesture {
                                    if selectedCategory == category {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }.frame(height: 32).padding(.horizontal, 1)
                    }.padding(.horizontal, 29).padding(.vertical, 10)
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Search History / Suggestions (when no search results)
                        if !searchHistory.isEmpty && productService.products.isEmpty && !productService.isLoading {
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("You may like").font(.system(size: 15)).fontWeight(.medium)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        searchHistory.removeAll()
                                        saveSearchHistory()
                                    }) {
                                        Text("Clear").font(.system(size: 13)).foregroundColor(.gray)
                                    }
                                }
                                
                                WrappingHStack(searchHistory, id: \.self, alignment: .leading) { term in
                                    Button(action: {
                                        searchTerm = term
                                        performSearch()
                                    }) {
                                        Text(term)
                                            .font(.system(size: 14))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(20)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }.padding(.top, 10)
                        }
                                           
                        // Loading State
                        if productService.isLoading {
                            VStack(spacing: 16) {
                                ProgressView().scaleEffect(1.5)
                                Text("Searching Etsy...").font(.system(size: 14)).foregroundColor(.gray)
                            }.frame(maxWidth: .infinity).padding(.vertical, 60)
                        }
                                            
                        // Error State
                        else if let errorMessage = productService.errorMessage {
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                                Text(errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                
                                Button(action: {
                                    performSearch()
                                }) {
                                    Text("Try Again")
                                        .font(.system(size: 14))
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }.frame(maxWidth: .infinity).padding(.vertical, 40)
                        }
                                            
                        // Empty State (searched but no results)
                        else if productService.products.isEmpty && !searchTerm.isEmpty && !productService.isLoading {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No results found for '\(searchTerm)'")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                Text("Try a different search term")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }.frame(maxWidth: .infinity).padding(.vertical, 60)
                        }
                        // Search Results Grid
                        else if !productService.products.isEmpty {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 30),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(destination: DetailPage(product: product)) {
                                        ListingItemView(product: product)
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        // Initial State (no search yet)
                        else if searchTerm.isEmpty && searchHistory.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Search Etsy products")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Text("Try 'dress', 'shoes', or 'accessories'")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }.frame(maxWidth: .infinity).padding(.vertical, 60)
                        }
                    }
                }
                
            }
            .padding(.horizontal, 30)
            .navigationBarHidden(true)
            .onAppear {
                isSearchFocused = true
                loadSearchHistory()
            }
        }
    }
    
    func performSearch() {
        guard !searchTerm.isEmpty else { return }
        
        // Add to search history
        if !searchHistory.contains(searchTerm) {
            searchHistory.insert(searchTerm, at: 0)
            
            if searchHistory.count > 6 {
                searchHistory.removeLast()
            }
            
            saveSearchHistory()
        }
        
        // Dismiss keyboard
        isSearchFocused = false
        
        // Search Etsy API
        Task {
            await productService.searchListings(query: searchTerm, limit: 50)
        }
        
        print("Searching for: \(searchTerm)")
    }
    
    // MARK: - Search History Persistence
    func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    func loadSearchHistory() {
        if let saved = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
            searchHistory = saved
        }
    }
}

//#Preview {
//    @Previewable @Namespace var animation
//    @Previewable @State var showSearchPage = true
//    
//    SearchPage(showSearchPage: $showSearchPage, animation: animation, productService: ProductService())
//}
