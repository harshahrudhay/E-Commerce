//
//  RegisterView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var loginVM: LoginVM
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Register")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .padding(.top)
                        
                        TextField("Username", text: $loginVM.username)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .autocapitalization(.none)
                        
                        TextField("Email", text: $loginVM.email)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $loginVM.password)
                            .autocorrectionDisabled(true)
                            .padding()
                            .glassEffect(.clear.interactive())
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .autocorrectionDisabled(true)
                            .padding()
                            .glassEffect(.clear.interactive())
                        
                        NavigationLink(destination: HomeView(loginVM: LoginVM()),
                                       isActive: $loginVM.isAuthenticated) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            guard confirmPassword == loginVM.password else {
                                loginVM.alertMessage = "Passwords do not match."
                                loginVM.showAlert = true
                                return
                            }
                            Task {
                                await loginVM.registerUser()
                            }
                        }) {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .glassEffect(.clear.interactive())
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 10)
                        
                        if loginVM.showAlert {
                            Text(loginVM.alertMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 80)
                    .padding(.top, 20)
                    .background(
                        LinearGradient(colors: [.pink.opacity(0.5), .purple.opacity(0.5)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .blur(radius: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    RegisterView(loginVM: LoginVM())
}
