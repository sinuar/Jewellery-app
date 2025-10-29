//
//  ProductDetailView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: CatalogView.DemoProduct
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoriteManager: FavoriteManager
    @EnvironmentObject var shoppingBagManager: ShoppingBagManager
    @State private var isInBag = false
    
    var body: some View {
        ZStack {
            // MARK: - Background Image
            GeometryReader { geometry in
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped() // This prevents the image from overflowing
            }
            .ignoresSafeArea()
            
            // MARK: - Top Buttons (Back + Favorite)
            VStack {
                HStack {
                    // Back Button
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .frame(width: 48, height: 48)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    
                    Spacer()
                    
                    // Favourite Button
                    Button(action: {
                        favoriteManager.toggleFavorite(for: product.id)
                    }) {
                        Image(systemName: favoriteManager.isFavorite(productId: product.id) ? "heart.fill" : "heart")
                            .font(.title2.bold())
                            .foregroundColor(favoriteManager.isFavorite(productId: product.id) ? .red : .black)
                            .frame(width: 48, height: 48)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                Spacer()
            }
            
            // MARK: - Bottom Product Details Card
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Gold, 18k, Embroidery option")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.subheadline.bold())
                            .foregroundColor(.black.opacity(0.8))
                    }
                    
                    Spacer()
                    
                     Button(action: {
                         withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                             isInBag.toggle()
                         }
                         if isInBag {
                             addToBag()
                         } else {
                             removeFromBag()
                         }
                     }) {
                        VStack(spacing: 4) {
                            Image(systemName: isInBag ? "bag.fill" : "bag")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(width: 42, height: 42)
                                .background(Color.black)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            
                            Text(isInBag ? "Added" : "Add to Bag")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .frame(height: 16)
                        }
                    }
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding(.horizontal, 16)
                .padding(.bottom, 26)
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
    }
    
    private func addToBag() {
        shoppingBagManager.add(product: product)
        print("Added \(product.name) to bag")
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    private func removeFromBag() {
        shoppingBagManager.remove(productId: product.id)
        print("Removed \(product.name) from bag")
    }
}

#Preview {
    NavigationView {
        ProductDetailView(
            product: CatalogView.DemoProduct(
                id: 1,
                name: "Diamond Ring",
                price: 1299.00,
                imageName: "rings01", category: .rings // replace with an image in your Assets
            )
        )
        .environmentObject(FavoriteManager())
    }
}

