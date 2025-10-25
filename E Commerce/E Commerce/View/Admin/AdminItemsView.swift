//
//  AdminItemsView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//



import SwiftUI
import FirebaseDatabase

struct AdminItemsView: View {
    
    @StateObject private var adminItemsVM = AdminItemsVM()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.4)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("All Added Products")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 40)
                        .shadow(radius: 10)
                    
                    if adminItemsVM.products.isEmpty {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Loading products...")
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .padding(.top, 50)
                    } else {
                        ForEach(adminItemsVM.products) { product in
                            VStack(alignment: .leading, spacing: 12) {
                                
                                HStack {
                                    Image(product.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 3)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(product.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("₹\(Int(product.cost)) • \(product.type)")
                                            .font(.subheadline)
                                            .foregroundColor(.black.opacity(0.8))
                                        Text(product.description)
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.7))
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                }
                                
                                HStack {
                                    Text(product.isAvailable ? "Available" : "Out of Stock")
                                        .font(.subheadline)
                                        .foregroundColor(product.isAvailable ? .green : .red)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { product.isAvailable },
                                        set: { newValue in
                                            adminItemsVM.updateAvailability(for: product, to: newValue)
                                        }
                                    ))
                                    .labelsHidden()
                                    
                                    Button(action: {
                                        adminItemsVM.deleteProduct(product)
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.white.opacity(0.15))
                                            .clipShape(Circle())
                                            .shadow(radius: 3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        AdminItemsView()
    }
}
