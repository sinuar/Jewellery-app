import Foundation

class FavoriteManager: ObservableObject {
    @Published private(set) var favoriteIds: Set<Int> = []
    
    private let defaults = UserDefaults.standard
    private let key = "favoriteProducts"
    
    init() {
        // Load saved favorites
        if let saved = defaults.array(forKey: key) as? [Int] {
            favoriteIds = Set(saved)
        }
    }
    
    func toggleFavorite(for productId: Int) {
        if favoriteIds.contains(productId) {
            favoriteIds.remove(productId)
        } else {
            favoriteIds.insert(productId)
        }
        // Save to UserDefaults
        defaults.set(Array(favoriteIds), forKey: key)
    }
    
    func isFavorite(productId: Int) -> Bool {
        favoriteIds.contains(productId)
    }
}
