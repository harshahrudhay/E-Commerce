//
//  AddProductVM.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//




import SwiftUI
import FirebaseDatabase
import Combine

@MainActor
final class AddProductVM: ObservableObject {
    
    @Published var productName: String = ""
    @Published var productCost: String = ""
    @Published var productDescription: String = ""
    @Published var imageName: String = ""
    @Published var productType: String = "Electronics"
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSaving: Bool = false
    
    private let dbRef = Database.database().reference()
    
    func addProductToRealtimeDB() async {
        guard !productName.trimmingCharacters(in: .whitespaces).isEmpty,
              !productCost.trimmingCharacters(in: .whitespaces).isEmpty,
              !productDescription.trimmingCharacters(in: .whitespaces).isEmpty,
              !imageName.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please fill all fields before saving."
            showAlert = true
            return
        }
        
        guard let costValue = Double(productCost) else {
            alertMessage = "Please enter a valid number for cost."
            showAlert = true
            return
        }
        
        isSaving = true
        
        do {
            let newProduct: [String: Any] = [
                "name": productName,
                "cost": costValue,
                "description": productDescription,
                "imageName": imageName,
                "type": productType,
                "available": true
            ]
            
            let productsRef = dbRef.child("products").childByAutoId()
            
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                productsRef.setValue(newProduct) { error, _ in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }
            
            alertMessage = "Product added successfully!"
            showAlert = true
            
            productName = ""
            productCost = ""
            productDescription = ""
            imageName = ""
            productType = "Electronics"
            
        } catch {
            alertMessage = "Error adding product: \(error.localizedDescription)"
            showAlert = true
        }
        
        isSaving = false
    }
}
