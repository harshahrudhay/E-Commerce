//
//  AdminProfileView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//


import SwiftUI

struct AdminProfileView: View {
    
    @ObservedObject var loginVM: LoginVM
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.6), .blue.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Text("Admin Profile")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 2, y: 2)
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 140, height: 140)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundStyle(.white)
                    }
                    
                    VStack(spacing: 5) {
                        Text(loginVM.username.isEmpty ? "Admin" : loginVM.username)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Text("Administrator Access")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.8))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
//                        .glassEffect(.clear)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    loginVM.logout()
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                        Text("Logout")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassEffect(.clear.interactive())
//                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    AdminProfileView(loginVM: LoginVM())
}
