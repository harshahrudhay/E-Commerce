//
//  ItemVM.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//



import Foundation
import FirebaseDatabase
import FirebaseAuth
import SwiftUI
import Combine

@MainActor
final class ItemsVM: ObservableObject {
    
    @Published var items: [ProductItem] = []
    @Published var cartItems: [ProductItem] = []
    @Published var orders: [Order] = []
    
    private var dbRef = Database.database().reference()
    
    init() {
        loadProductsFromFirebase()
        observeCartUpdates()
        observeOrders()
    }
    
    private func loadProductsFromFirebase() {
        let productsRef = dbRef.child("products")
        
        productsRef.observe(.value) { snapshot in
            var newItems: [ProductItem] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                   let name = data["name"] as? String,
                   let cost = data["cost"] as? Double,
                   let imageName = data["imageName"] as? String {
                    
                    let isAvailable = data["available"] as? Bool ?? true
                    
                    newItems.append(ProductItem(
                        imageName: imageName,
                        itemName: name,
                        itemCost: cost,
                        isAvailable: isAvailable
                    ))
                }
            }
            
            if newItems.isEmpty {
                self.loadLocalItems()
            } else {
                self.items = newItems
            }
        }
    }
    
    private func loadLocalItems() {
        self.items = [
            ProductItem(imageName: "pizza", itemName: "Margherita Pizza", itemCost: 249.0),
            ProductItem(imageName: "burger", itemName: "Veg Burger", itemCost: 99.0),
            ProductItem(imageName: "pasta", itemName: "Italian Pasta", itemCost: 199.0),
            ProductItem(imageName: "sandwich", itemName: "Club Sandwich", itemCost: 149.0),
            ProductItem(imageName: "fries", itemName: "French Fries", itemCost: 79.0),
            ProductItem(imageName: "salad", itemName: "Green Salad", itemCost: 129.0),
            ProductItem(imageName: "juice", itemName: "Orange Juice", itemCost: 59.0)
        ]
    }
    
    func addToCart(_ item: ProductItem) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let cartRef = dbRef.child("carts").child(userID).child(item.itemName)
        
        let itemData: [String: Any] = [
            "itemName": item.itemName,
            "itemCost": item.itemCost,
            "imageName": item.imageName
        ]
        
        cartRef.setValue(itemData)
    }
    
    func removeFromCart(_ item: ProductItem) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        dbRef.child("carts").child(userID).child(item.itemName).removeValue()
    }
    
    func observeCartUpdates() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let cartRef = dbRef.child("carts").child(userID)
        
        cartRef.observe(.value) { snapshot in
            var newItems: [ProductItem] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                   let name = data["itemName"] as? String,
                   let cost = data["itemCost"] as? Double,
                   let imageName = data["imageName"] as? String {
                    newItems.append(ProductItem(imageName: imageName, itemName: name, itemCost: cost))
                }
            }
            self.cartItems = newItems
        }
    }
    
    func placeOrder(cartItems: [CartItem]) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let orderRef = dbRef.child("orders").child(userID).childByAutoId()
        
        let orderData: [String: Any] = [
            "id": orderRef.key ?? UUID().uuidString,
            "items": cartItems.map { [
                "itemName": $0.itemName,
                "itemCost": $0.itemCost,
                "imageName": $0.imageName,
                "quantity": $0.quantity
            ] },
            "timestamp": Int(Date().timeIntervalSince1970)
        ]
        
        orderRef.setValue(orderData)
        
        dbRef.child("carts").child(userID).removeValue()
        self.cartItems.removeAll()
    }

    func observeOrders() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ordersRef = dbRef.child("orders").child(userID)
        
        ordersRef.observe(.value) { snapshot in
            var newOrders: [Order] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let data = snap.value as? [String: Any],
                   let itemsData = data["items"] as? [[String: Any]] {
                    
                    var items: [CartItem] = []
                    for i in itemsData {
                        if let name = i["itemName"] as? String,
                           let cost = i["itemCost"] as? Double,
                           let imageName = i["imageName"] as? String,
                           let qty = i["quantity"] as? Int {
                            items.append(CartItem(id: UUID(), imageName: imageName, itemName: name, itemCost: cost, quantity: qty))
                        }
                    }
                    
                    let order = Order(
                        id: data["id"] as? String ?? UUID().uuidString,
                        items: items,
                        timestamp: data["timestamp"] as? Int ?? 0
                    )
                    newOrders.append(order)
                }
            }
            self.orders = newOrders.sorted { $0.timestamp > $1.timestamp }
        }
    }
}
