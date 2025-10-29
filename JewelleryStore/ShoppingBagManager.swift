//
//  ShoppingBagManager.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 10/29/25.
//

import Foundation

final class ShoppingBagManager: ObservableObject {
    struct ShoppingBagItem: Identifiable {
        let id: Int
        let product: CatalogView.DemoProduct
        var quantity: Int
    }

    @Published private(set) var items: [ShoppingBagItem] = []

    func add(product: CatalogView.DemoProduct, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index].quantity += quantity
        } else {
            items.append(ShoppingBagItem(id: product.id, product: product, quantity: max(1, quantity)))
        }
    }

    func remove(productId: Int) {
        items.removeAll { $0.id == productId }
    }

    func increment(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        items[index].quantity += 1
    }

    func decrement(productId: Int) {
        guard let index = items.firstIndex(where: { $0.id == productId }) else { return }
        items[index].quantity = max(1, items[index].quantity - 1)
    }

    func contains(productId: Int) -> Bool {
        items.contains { $0.id == productId }
    }

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Double {
        items.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) }
    }
}


