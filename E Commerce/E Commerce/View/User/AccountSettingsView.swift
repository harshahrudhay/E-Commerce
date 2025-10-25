//
//  AccountSettingsView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountSettingsView: View {
    
    @ObservedObject var loginVM: LoginVM
    @State var goToLogin = false
    
    @State private var editedUsername: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSavedAlert = false
    @State private var showLogoutAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    private var hasChanges: Bool {
        guard let user = user else { return false }
        return (!editedUsername.isEmpty && editedUsername != loginVM.username) ||
               (!email.isEmpty && email != user.email) ||
               !password.isEmpty
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.pink.opacity(0.5), .purple.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Account Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    
                    VStack(spacing: 20) {
                        TextField("Username", text: $editedUsername)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(12)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(12)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(12)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(12)
                        
                        Button(action: { Task { await saveChanges() } }) {
                            Text(isSaving ? "Saving..." : "Save Changes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .opacity(hasChanges ? 1 : 0.5)
                        }
                        .disabled(!hasChanges || isSaving)
                        .glassEffect(.clear.interactive())
                        .cornerRadius(12)
                        
                        Button(role: .destructive) {
                            showLogoutAlert = true
                        } label: {
                            Text("Logout")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .glassEffect(.clear.interactive())
                                .cornerRadius(12)
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 5)
                        .alert("Do you want to logout?", isPresented: $showLogoutAlert) {
                            Button("Yes", role: .destructive) {
                                Task {
                                    try? Auth.auth().signOut()
                                    goToLogin = true
                                }
                            }
                            Button("No", role: .cancel) { }
                        }
                        
                        .navigationDestination(isPresented: $goToLogin) {
                            LoginView()
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 25)
                    .background(
                        LinearGradient(
                            colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .blur(radius: 20)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            editedUsername = loginVM.username
            email = loginVM.email
        }
        .alert("Data updated successfully!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    @MainActor
    private func saveChanges() async {
        guard let user = user else { return }
        
        if !password.isEmpty && password != confirmPassword {
            errorMessage = "Passwords do not match."
            showErrorAlert = true
            return
        }
        
        isSaving = true
        
        do {
            var updates: [String: Any] = [:]
            
            if !editedUsername.isEmpty && editedUsername != loginVM.username {
                updates["username"] = editedUsername
                loginVM.username = editedUsername
            }
            
            if !email.isEmpty && email != user.email {
                try await user.updateEmail(to: email)
                updates["email"] = email
                loginVM.email = email
            }
            
            if !password.isEmpty {
                try await user.updatePassword(to: password)
            }
            
            if !updates.isEmpty {
                try await db.collection("users").document(user.uid).updateData(updates)
            }
            
            password = ""
            confirmPassword = ""
            
            showSavedAlert = true
            
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
        
        isSaving = false
    }
}

#Preview {
    AccountSettingsView(loginVM: LoginVM())
}
