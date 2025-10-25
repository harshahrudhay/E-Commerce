//
//  ProductItem.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import Foundation

struct ProductItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let itemName: String
    let itemCost: Double
    var isAvailable: Bool = true
//    let itemDescription: String
}


