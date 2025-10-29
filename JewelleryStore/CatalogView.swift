//
//  CatalogView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct JewelleryItem: Identifiable, Decodable {
    let id: Int
    let name: String
    let price: Double
}

struct CatalogView: View {
    @State private var items: [JewelleryItem] = []
    @State private var errorMessage: String = ""
    @State private var selectedCategory: Category = .all
    @State private var selectedTab: Tab = .home
    @AppStorage("userEmail") private var userEmail: String = ""
    
    enum Tab {
        case home
        case favorites
        case bag
    }
    
    enum Category: String, CaseIterable, Identifiable {
        case all = "All"
        case rings = "Rings"
        case necklaces = "Necklaces"
        case earrings = "Earrings"
        case bracelets = "Bracelets"
        var id: String { rawValue }
    }
    
    struct DemoProduct: Identifiable {
        let id: Int
        let name: String
        let price: Double
        let imageName: String
        let category: Category
    }
    
    private var demoProducts: [DemoProduct] {
        [
            DemoProduct(id: 1, name: "Diamond Ring", price: 1299.0, imageName: "rings01", category: .rings),
            DemoProduct(id: 2, name: "Emerald Necklace", price: 1799.0, imageName: "necklace01", category: .necklaces),
            DemoProduct(id: 3, name: "Gold Bracelet", price: 899.0, imageName: "bracelet01", category: .bracelets),
            DemoProduct(id: 4, name: "Pearl Earrings", price: 499.0, imageName: "earrings01", category: .earrings)
        ]
    }
    
    private var greetingName: String {
        if let namePart = userEmail.split(separator: "@").first, !namePart.isEmpty {
            return String(namePart).capitalized
        }
        return "Guest"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                switch selectedTab {
                case .home:
                    // Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello! \(greetingName)")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                Image(systemName: "magnifyingglass")
                                    .font(.title2)
                            }
                            Button(action: {}) {
                                Image(systemName: "person.circle")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                    // Categories horizontal scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Category.allCases) { category in
                                Button(action: { selectedCategory = category }) {
                                    Text(category.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(category == selectedCategory ? Color.accentColor.opacity(0.9) : Color.gray.opacity(0.15))
                                        )
                                        .foregroundColor(category == selectedCategory ? .white : .primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }

                    // Grid of products
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredDemoProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Image(product.imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 150)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                        Text(product.name)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                        Text("$\(product.price, specifier: "%.2f")")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        Spacer(minLength: 80)
                    }

                    // Bottom fixed bar
                    HStack {
                        Button(action: { selectedTab = .home }) {
                            VStack(spacing: 4) {
                                Image(systemName: selectedTab == .home ? "house.fill" : "house")
                                Text("Home").font(.caption2)
                            }
                        }
                        .foregroundColor(selectedTab == .home ? .accentColor : .primary)
                        Spacer()
                        Button(action: { selectedTab = .favorites }) {
                            VStack(spacing: 4) {
                                Image(systemName: selectedTab == .favorites ? "heart.fill" : "heart")
                                Text("Favourites").font(.caption2)
                            }
                        }
                        .foregroundColor(selectedTab == .favorites ? .accentColor : .primary)
                        Spacer()
                        Button(action: { selectedTab = .bag }) {
                            VStack(spacing: 4) {
                                Image(systemName: selectedTab == .bag ? "bag.fill" : "bag")
                                Text("Bag").font(.caption2)
                            }
                        }
                        .foregroundColor(selectedTab == .bag ? .accentColor : .primary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    
                case .favorites:
                    FavoritesView(demoProducts: demoProducts)
                    
                case .bag:
                    Text("Shopping Bag")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear(perform: fetchCatalogue)
    }

    func fetchCatalogue() {
        NetworkManager.shared.get(endpoint: "/catalogue") { (result: Result<[JewelleryItem], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedItems):
                    items = fetchedItems
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private var filteredDemoProducts: [DemoProduct] {
        switch selectedCategory {
        case .all:
            return demoProducts
        case .rings:
            return demoProducts.filter { $0.category == .rings }
        case .necklaces:
            return demoProducts.filter { $0.category == .necklaces }
        case .earrings:
            return demoProducts.filter { $0.category == .earrings }
        case .bracelets:
            return demoProducts.filter { $0.category == .bracelets }
        }
    }
}

#Preview {
    CatalogView()
}
