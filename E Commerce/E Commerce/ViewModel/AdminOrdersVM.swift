//
//  AdminOrdersVM.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//


import Foundation
import FirebaseDatabase
import Combine

struct AdminOrderItem: Identifiable {
    let id = UUID()
    let itemName: String
    let imageName: String
    let itemCost: Double
    let quantity: Int
}

struct AdminOrder: Identifiable {
    let id: String
    let userId: String
    var username: String
    let items: [AdminOrderItem]
    let timestamp: Int
}

@MainActor
final class AdminOrdersVM: ObservableObject {
    @Published var orders: [AdminOrder] = []
    
    private let dbRef = Database.database().reference()
    private var usernamesCache: [String: String] = [:]
    
    init() {
        observeAllOrders()
    }
    
    func observeAllOrders() {
        let ordersRef = dbRef.child("orders")
        
        ordersRef.observe(.value) { [weak self] snapshot in
            guard let self else { return }
            var fetched: [AdminOrder] = []
            
            for userChild in snapshot.children {
                guard let userSnap = userChild as? DataSnapshot else { continue }
                let userId = userSnap.key
                
                for orderChild in userSnap.children {
                    guard let orderSnap = orderChild as? DataSnapshot,
                          let data = orderSnap.value as? [String: Any],
                          let itemsData = data["items"] as? [[String: Any]] else {
                        continue
                    }
                    
                    var items: [AdminOrderItem] = []
                    for i in itemsData {
                        let name = i["itemName"] as? String ?? "Unknown"
                        let image = i["imageName"] as? String ?? ""
                        let cost = i["itemCost"] as? Double ?? 0.0
                        let qty = i["quantity"] as? Int ?? 1
                        items.append(AdminOrderItem(itemName: name, imageName: image, itemCost: cost, quantity: qty))
                    }
                    
                    let username = self.usernamesCache[userId] ?? "Loading..."
                    
                    let order = AdminOrder(
                        id: data["id"] as? String ?? orderSnap.key,
                        userId: userId,
                        username: username,
                        items: items,
                        timestamp: data["timestamp"] as? Int ?? 0
                    )
                    
                    fetched.append(order)
                    
                    if self.usernamesCache[userId] == nil {
                        self.fetchUsername(for: userId)
                    }
                }
            }
            
            self.orders = fetched.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    private func fetchUsername(for userId: String) {
        let userRef = dbRef.child("users").child(userId)
        userRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self else { return }
            if let data = snapshot.value as? [String: Any],
               let username = data["username"] as? String {
                Task { @MainActor in
                    self.usernamesCache[userId] = username
                    for (index, order) in self.orders.enumerated() where order.userId == userId {
                        self.orders[index].username = username
                    }
                }
            } else {
                self.usernamesCache[userId] = "Unknown"
            }
        }
    }
}
