//
//  LoginVM.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class LoginVM: ObservableObject {
    
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isAdmin: Bool = false
    @Published var showRegister: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var cartItems: [ProductItem] = []
    
    private let db = Firestore.firestore()
    
    private func validateFields(forRegister: Bool = false) -> Bool {
        if forRegister {
            if username.trimmingCharacters(in: .whitespaces).isEmpty ||
                email.trimmingCharacters(in: .whitespaces).isEmpty ||
                password.trimmingCharacters(in: .whitespaces).isEmpty {
                alertMessage = "Please fill all fields before registering."
                showAlert = true
                return false
            }
        } else {
            if username.trimmingCharacters(in: .whitespaces).isEmpty ||
                password.trimmingCharacters(in: .whitespaces).isEmpty {
                alertMessage = "Please fill all fields before logging in."
                showAlert = true
                return false
            }
        }
        return true
    }
    
    func loginUser() async {
        guard validateFields() else { return }
        
        if username == "admin" && password == "123456" {
            isAdmin = true
            isAuthenticated = true
            return
        }
        
        do {
            let snapshot = try await db.collection("users")
                .whereField("username", isEqualTo: username)
                .getDocuments()
            
            if let userDoc = snapshot.documents.first {
                let data = userDoc.data()
                if let email = data["email"] as? String {
                    do {
                        _ = try await Auth.auth().signIn(withEmail: email, password: password)
                        isAuthenticated = true
                    } catch {
                        alertMessage = "Invalid credentials. Please check your password."
                        showAlert = true
                    }
                } else {
                    alertMessage = "User not found in database."
                    showAlert = true
                }
            } else {
                alertMessage = "User not found. Please register."
                showAlert = true
                showRegister = true
            }
            
        } catch {
            alertMessage = "Error checking user: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func registerUser() async {
        guard validateFields(forRegister: true) else { return }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            try await db.collection("users").document(uid).setData([
                "username": username,
                "email": email,
                "password": password
            ])
            
            isAuthenticated = true
            showRegister = false
        } catch {
            alertMessage = "Failed to register: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            isAdmin = false
            username = ""
            email = ""
            password = ""
        } catch {
            alertMessage = "Failed to logout: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
