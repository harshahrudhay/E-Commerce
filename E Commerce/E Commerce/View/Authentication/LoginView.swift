//
//  LoginView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @StateObject private var loginVM = LoginVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.5), .purple.opacity(0.5)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("delivery")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding(.top, 30)
                    
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                            .padding(.top)
                        
                        TextField("Username", text: $username)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .glassEffect(.clear.interactive())
                        
                        NavigationLink(destination: RegisterView(loginVM: loginVM),
                                       isActive: $loginVM.showRegister) {
                            EmptyView()
                        }
                        
                        if loginVM.isAuthenticated {
                            if loginVM.isAdmin {
                                NavigationLink(destination: AdminTabView(loginVM: loginVM),
                                               isActive: $loginVM.isAuthenticated) {
                                    EmptyView()
                                }
                            } else {
                                NavigationLink(destination: HomeView(loginVM: loginVM)
                                    .environmentObject(ItemsVM()),
                                               isActive: $loginVM.isAuthenticated) {
                                    EmptyView()
                                }
                            }
                        }
                        
                        Button(action: {
                            Task {
                                loginVM.username = username
                                loginVM.password = password
                                

                                if username == "admin" && password == "123456" {
                                    loginVM.isAdmin = true
                                    loginVM.isAuthenticated = true
                                } else {
                                    loginVM.isAdmin = false
                                    await loginVM.loginUser()
                                }
                            }
                        }) {
                            Text("Login")
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
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 90)
                    .padding(.top, 20)
                    .background(
                        LinearGradient(colors: [.pink.opacity(0.5), .purple.opacity(0.5)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                            .blur(radius: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                    )
                    .padding(.horizontal)
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    LoginView()
}
