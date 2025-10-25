//
//  CartView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import SwiftUI

struct CartView: View {
    
    @ObservedObject var loginVM: LoginVM
    @EnvironmentObject var itemsVM: ItemsVM
    @State private var quantities: [UUID: Int] = [:]
    @State private var showOrders = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    
                    Text("Cart")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: { showOrders = true }) {
                        Image(systemName: "bag.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(3)
                        
                    }
                    .buttonStyle(.glass)
                    
                }
                .padding()
                
                if itemsVM.cartItems.isEmpty {
                    Spacer()
                    Text("Your cart is empty")
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(itemsVM.cartItems) { item in
                                HStack(spacing: 15) {
                                    Image(item.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(10)
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.itemName)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("₹\(String(format: "%.2f", item.itemCost))")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black.opacity(0.9))
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 10) {
                                        Button(action: {
                                            let currentQty = quantities[item.id] ?? 1
                                            if currentQty > 1 {
                                                quantities[item.id] = currentQty - 1
                                            } else {
                                                quantities.removeValue(forKey: item.id)
                                                itemsVM.removeFromCart(item)
                                            }
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        }
                                        
                                        Text("\(quantities[item.id] ?? 1)")
                                            .frame(minWidth: 20)
                                            .foregroundColor(.black)
                                        
                                        Button(action: {
                                            let currentQty = quantities[item.id] ?? 1
                                            quantities[item.id] = currentQty + 1
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding()
                    }
                    
                    VStack(spacing: 12) {
                        let total = itemsVM.cartItems.reduce(0) { $0 + ($1.itemCost * Double(quantities[$1.id] ?? 1)) }
                        
                        HStack {
                            Text("Total: ")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                            Text("₹\(String(format: "%.2f", total))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            let cartForOrder = itemsVM.cartItems.map { item in
                                CartItem(id: item.id,
                                         imageName: item.imageName,
                                         itemName: item.itemName,
                                         itemCost: item.itemCost,
                                         quantity: quantities[item.id] ?? 1)
                            }
                            itemsVM.placeOrder(cartItems: cartForOrder)
                            quantities.removeAll()
                            showOrders = true
                        }) {
                            Text("Place Order")
                                .foregroundColor(.black)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .glassEffect(.clear.interactive())
                                .cornerRadius(15)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            
            NavigationLink(destination: OrderView().environmentObject(itemsVM), isActive: $showOrders) { EmptyView() }
        }
        .onAppear {
            for item in itemsVM.cartItems { quantities[item.id] = 1 }
        }
        .onChange(of: itemsVM.cartItems.count) { _ in
            for item in itemsVM.cartItems { if quantities[item.id] == nil { quantities[item.id] = 1 } }
        }
    }
}

#Preview {
    CartView(loginVM: LoginVM())
        .environmentObject(ItemsVM())
}
