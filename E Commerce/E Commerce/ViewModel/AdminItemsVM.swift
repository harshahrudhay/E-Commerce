//
//  AdminItemsVM.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//


import Foundation
import FirebaseDatabase
import Combine

struct AdminProduct: Identifiable {
    let id: String
    let name: String
    let cost: Double
    let description: String
    let imageName: String
    let type: String
    var isAvailable: Bool
}

@MainActor
final class AdminItemsVM: ObservableObject {
    
    @Published var products: [AdminProduct] = []
    
    private let dbRef = Database.database().reference()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        let productsRef = dbRef.child("products")
        
        productsRef.observe(.value) { snapshot in
            var fetchedProducts: [AdminProduct] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                   let name = data["name"] as? String,
                   let cost = data["cost"] as? Double,
                   let description = data["description"] as? String,
                   let imageName = data["imageName"] as? String,
                   let type = data["type"] as? String {
                    
                    let isAvailable = data["available"] as? Bool ?? true
                    
                    fetchedProducts.append(AdminProduct(
                        id: snap.key,
                        name: name,
                        cost: cost,
                        description: description,
                        imageName: imageName,
                        type: type,
                        isAvailable: isAvailable
                    ))
                }
            }
            
            self.products = fetchedProducts.reversed()
        }
    }
    
    func updateAvailability(for product: AdminProduct, to newStatus: Bool) {
        dbRef.child("products").child(product.id).child("available").setValue(newStatus)
    }
    
    func deleteProduct(_ product: AdminProduct) {
        dbRef.child("products").child(product.id).removeValue { [weak self] error, _ in
            if let error = error {
                print("Failed to delete product: \(error.localizedDescription)")
            } else {
                print("Product deleted successfully")
                self?.products.removeAll { $0.id == product.id }
            }
        }
    }
}
