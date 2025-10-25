//
//  AdminOrdersView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//



import SwiftUI

struct AdminOrdersView: View {
    @StateObject private var vm = AdminOrdersVM()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Admin - Orders")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.black)
                
                if vm.orders.isEmpty {
                    Spacer()
                    Text("No orders yet")
                        .foregroundColor(.black)
                        .font(.title3)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.orders) { order in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Order: \(order.id.prefix(5))")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("User: \(order.username)")
                                                .font(.caption)
                                                .foregroundColor(.black.opacity(0.8))
                                        }
                                        Spacer()
                                        Text(dateString(from: order.timestamp))
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.8))
                                    }
                                    
                                    ForEach(order.items) { item in
                                        HStack(spacing: 12) {
                                            if !item.imageName.isEmpty {
                                                Image(item.imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                            } else {
                                                Rectangle()
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                                    .opacity(0.15)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(item.itemName)
                                                    .foregroundColor(.black)
                                                Text("Qty: \(item.quantity) • ₹\(String(format: "%.2f", item.itemCost * Double(item.quantity)))")
                                                    .foregroundColor(.black.opacity(0.8))
                                                    .font(.caption)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
    }
    
    private func dateString(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    AdminOrdersView()
}
