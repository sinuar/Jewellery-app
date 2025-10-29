//
//  ShoppingBagView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 10/29/25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var selectedTab: CatalogView.Tab
    @EnvironmentObject var favoriteManager: FavoriteManager
    let demoProducts: [CatalogView.DemoProduct]
    
    private var favoriteProducts: [CatalogView.DemoProduct] {
        demoProducts.filter { favoriteManager.isFavorite(productId: $0.id) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: { selectedTab = .home }) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.12))
                        .clipShape(Circle())
                }
                Text("Favorites")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            ScrollView {
                if favoriteProducts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No favorites yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 100)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(favoriteProducts) { product in
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
                }
            }
        }
    }
}

