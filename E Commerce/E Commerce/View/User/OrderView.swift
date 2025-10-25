//
//  OrderView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//


import SwiftUI

struct OrderView: View {
    
    @EnvironmentObject var itemsVM: ItemsVM
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("My Orders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .foregroundColor(.black)
                
                if itemsVM.orders.isEmpty {
                    Spacer()
                    Text("No orders yet")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.title3)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(itemsVM.orders) { order in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("Order ID: \(order.id.prefix(5))")
                                            .font(.subheadline)
                                        Spacer()
                                        Text(order.formattedDate)
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.7))
                                    }

                                    Divider().background(.white.opacity(0.3))

                                    ForEach(order.items) { item in
                                        HStack(spacing: 12) {
                                            Image(item.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(10)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(item.itemName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                Text("Qty: \(item.quantity) | ₹\(String(format: "%.2f", item.itemCost * Double(item.quantity)))")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }

                                            Spacer()
                                        }
                                    }

                                    Divider()
                                        .background(.black.opacity(0.3))

                                    HStack {
                                        Spacer()
                                        let total = order.items.reduce(0) { $0 + ($1.itemCost * Double($1.quantity)) }
                                        Text("Total: ₹\(String(format: "%.2f", total))")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)
                            }

                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    OrderView()
}
