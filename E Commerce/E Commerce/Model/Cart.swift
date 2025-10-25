//
//  Cart.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//



import Foundation

struct CartItem: Identifiable {
    let id: UUID
    let imageName: String
    let itemName: String
    let itemCost: Double
    var quantity: Int
}

struct Order: Identifiable {
    let id: String
    let items: [CartItem]
    let timestamp: Int
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

