//
//  HomePage.swift
//  mms_lec
//
//  Created by Visitor on 06/10/25.
//

import SwiftUI

struct HomePage: View {
    @StateObject private var productService = ProductService()
    @State private var searchTerm = ""
    @State private var searchHistory: [String] = []
    @State private var currentIndex = 0
    @State private var selectedCategory: Categories? = nil
    @State private var isSearchBarPressed = false
    @State private var showSearchPage = false
    @Namespace private var animation
    private var categories = Categories.allCases
    var slides : [String] = ["Image1", "Image2"]
    
    var filteredProducts: [Products] {
        let products = productService.products.isEmpty ? productList : productService.products
                
                if let selected = selectedCategory {
                    return products.filter { $0.categories.contains(selected) }
                }
                return products
        }
     
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Color.cream
                        .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0){
                        HStack {
                            Text("Discover").fontWeight(.medium).font(.system(size: 24))
                            Spacer()
                        }.padding(.horizontal, 30)
                        HStack {
    //                        SearchBar(search: $searchTerm,
    //                                  searchHistory: $searchHistory,
    //                                  onSearch: performSearch).padding(.vertical, 18)
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showSearchPage = true
                                }
                            }) {
                                ZStack {
                                    Rectangle().foregroundStyle(Color.cream2).frame(height: 50).clipShape(RoundedRectangle(cornerRadius: 10))
                                    HStack {
                                        Text("Search").foregroundStyle(Color.font).font(.system(size: 14)).fontWeight(.medium).animation(.easeOut(duration: 0.2), value: isSearchBarPressed)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "magnifyingglass").foregroundStyle(Color.font).font(.system(size: 15))
                                    }.padding(.horizontal, 25).animation(.easeOut(duration: 0.2), value: isSearchBarPressed)
                                        
                                }.padding(.leading, 30).animation(.easeOut(duration: 0.2), value: isSearchBarPressed).matchedGeometryEffect(id: "searchBar", in: animation).buttonStyle(.plain)
                            }
                            
                           
                            
                            NavigationLink(destination: CartPage()){
                                CartButton(numberOfProducts: 10)
                            }.padding(.trailing, 30)
                            
                        }.padding(.vertical, 18)
                    }.frame(alignment: .leading)
                    
                    ImageSliderView().padding(.bottom, 30).padding(.horizontal, 30)
                    
                    VStack {
                        HStack {
                            Text("Categories").font(.system(size: 16))
                            Spacer()
    //                        Text("See All").font(.system(size: 13))
                            NavigationLink(destination: CategoryPage(), label: {
                                Text("See All").foregroundStyle(Color.black).font(.system(size: 13))
                            }).buttonStyle(.plain)
                        }.padding(.horizontal, 30)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) {
                                    category in CategoryItemView(isSelected: selectedCategory == category, title: category.rawValue, onDeselect: {
                                        selectedCategory = nil
                                    }).onTapGesture {
                                        if selectedCategory == category {
                                            selectedCategory = nil
                                        } else {
                                            selectedCategory = category
                                        }
                                        
                                    }
                                }
                            }.frame(height: 32).padding(.horizontal, 1)
                        }.padding(.horizontal, 29).padding(.bottom, 10)
                    }
                    
                    if productService.isLoading {
                        VStack(spacing: 16) {
                            ProgressView().scaleEffect(1.5)
                            Text("Loading products from Etsy...").font(.system(size: 14)).foregroundColor(.gray)
                        }.frame(maxWidth: .infinity).padding(.vertical, 60)
                    } else if let errorMessage = productService.errorMessage {
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
                                Task {
                                    await loadProducts()
                                }
                            }) {
                                Text("Retry")
                                    .font(.system(size: 14))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 30),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: DetailPage(product: product)) {
                                    ListingItemView(product: product)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }.padding(.horizontal, 30)
                    }
                    
//                    LazyVGrid(columns: [
//                        GridItem(.flexible(), spacing: 30),
//                        GridItem(.flexible())
//                    ], spacing: 10) {
//                        ForEach(filteredProducts) { product in
//    //                        product in ListingItemView(product: product)
//                            NavigationLink(destination: DetailPage(product: product)) {
//                                ListingItemView(product: product)
//                            }.buttonStyle(PlainButtonStyle())
//                        }
//                    }.padding(.horizontal, 30)
                    
                    
                    
                }.refreshable {
                    await loadProducts()
                }
            }
            
            }.opacity(showSearchPage ? 0 : 1).onAppear {
                if productService.products.isEmpty {
                    Task {
                        await loadProducts()
                    }
                }
            }
            
            if showSearchPage {
                SearchPage(showSearchPage: $showSearchPage, animation: animation).transition(.opacity).zIndex(1)
            }
        }
            
        
        
    }
    
    func loadProducts() async {
        await productService.searchListings(query: "clothing", limit: 50)
    }
    
    func performSearch() {
            guard !searchTerm.isEmpty else { return }
            
            if !searchHistory.contains(searchTerm) {
                searchHistory.insert(searchTerm, at: 0)
                
                if searchHistory.count > 6 {
                    searchHistory.removeLast()
                }
            }
            
            print("Searching for: \(searchTerm)")
        }
}

#Preview {
    HomePage()
}
