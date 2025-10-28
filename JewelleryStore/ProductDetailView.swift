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
    @State private var isFavorited = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            // Main product image
            Image(product.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Top navigation bar
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: { isFavorited.toggle() }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorited ? .red : .white)
                            .padding(12)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Spacer()
            }
            
            // Bottom overlay with product details
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    // Product name
                    Text(product.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Price
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    
                    // Add to bag button
                    Button(action: addToBag) {
                        HStack {
                            Image(systemName: "bag")
                            Text("Add to Bag")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    private func addToBag() {
        // TODO: Implement add to bag functionality
        print("Added \(product.name) to bag")
    }
}

#Preview {
    ProductDetailView(product: CatalogView.DemoProduct(
        id: 1,
        name: "Diamond Ring",
        price: 1299.0,
        imageName: "rings01",
        category: .rings
    ))
}
