


// CartManager.swift
import UIKit
struct CartItem {
    let image: UIImage
    let title: String
}

class CartManager {
    static let shared = CartManager()
    private init() {}
    
    var items: [CartItem] = []
    
    func addItem(_ item: CartItem) {
        items.append(item)
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
}
