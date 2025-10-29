import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoriteManager = FavoriteManager.shared
    let demoProducts: [CatalogView.DemoProduct]
    
    private var favoriteProducts: [CatalogView.DemoProduct] {
        demoProducts.filter { favoriteManager.isFavorite(productId: $0.id) }
    }
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Favorites")
        }
    }
}