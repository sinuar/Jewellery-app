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
    // imageName removed for backend simplicity
}

struct CatalogView: View {
    @State private var items: [JewelleryItem] = []
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            List(items) { item in
                HStack {
                    Image(systemName: "star") // Replace with actual images
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("$\(item.price, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Jewellery Catalog")
            .onAppear(perform: fetchCatalogue)
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
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
}

#Preview {
    CatalogView()
}
