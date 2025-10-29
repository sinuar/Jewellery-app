//
//  JewelleryStoreApp.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

@main
struct JewelleryStoreApp: App {
    @StateObject private var favoriteManager = FavoriteManager()
    @StateObject private var shoppingBagManager = ShoppingBagManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteManager)
                .environmentObject(shoppingBagManager)
        }
    }
}
