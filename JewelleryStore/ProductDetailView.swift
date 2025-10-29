//
//  ProductDetailView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

import SwiftUI

struct ProductDetailView: View {
    let product: CatalogView.DemoProduct
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorited = false
    
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
                            .font(.title3.bold())
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    
                    Spacer()
                    
                    // Favorite Button
                    Button(action: { isFavorited.toggle() }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.title3.bold())
                            .foregroundColor(isFavorited ? .red : .black)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
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
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("$\(product.price, specifier: "%.2f")")
                            .font(.subheadline.bold())
                            .foregroundColor(.black.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Button(action: addToBag) {
                        Image(systemName: "arrow.right")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 42, height: 42)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 3)
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
    }
    
    private func addToBag() {
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
