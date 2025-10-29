//
//  ShoppingBagView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 10/29/25.
//

import SwiftUI

struct ShoppingBagView: View {
    @EnvironmentObject var shoppingBagManager: ShoppingBagManager
    var onBack: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.12))
                        .clipShape(Circle())
                }
                Text("Shopping Bag")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                if shoppingBagManager.totalItems > 0 {
                    Text("\(shoppingBagManager.totalItems)")
                        .font(.subheadline)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            if shoppingBagManager.items.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bag")
                        .font(.system(size: 44))
                        .foregroundColor(.secondary)
                    Text("Your bag is empty")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(shoppingBagManager.items, id: \ .id) { item in
                        HStack(spacing: 12) {
                            Image(item.product.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.product.name)
                                    .font(.subheadline)
                                Text("$\(item.product.price, specifier: "%.2f")")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Button(action: { shoppingBagManager.decrement(productId: item.id) }) {
                                    Image(systemName: "minus.circle")
                                }
                                .buttonStyle(.borderless)
                                
                                Text("\(item.quantity)")
                                    .frame(minWidth: 24)
                                Button(action: { shoppingBagManager.increment(productId: item.id) }) {
                                    Image(systemName: "plus.circle")
                                }
                                .buttonStyle(.borderless)
                            }
                            Button(role: .destructive, action: { shoppingBagManager.remove(productId: item.id) }) {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                    }
                }
                .listStyle(.inset)

                // Footer with subtotal and checkout
                VStack(spacing: 12) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text("$\(shoppingBagManager.subtotal, specifier: "%.2f")")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)

                    Button(action: {}) {
                        Text("Checkout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    ShoppingBagView()
        .environmentObject(ShoppingBagManager())
}


