//
//  ItemRowView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import SwiftUI

struct ItemRowView: View {
    
    let imageName: String
    let itemName: String
    let itemCost: Double
    let isAvailable: Bool
    
    @Binding var selectedItem: ProductItem?
    
    let isInCart: Bool
    
    let addToCartAction: () -> Void
    
    @State private var isFavorite: Bool = false
    @State private var showDetail: Bool = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 15) {
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(itemName)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.black)
                    
                    Text("Quantity: 1 pcs")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text("₹\(String(format: "%.2f", itemCost))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    if !isAvailable {
                        Text("Out of Stock")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .pink.opacity(0.7))
                            .font(.title2)
                    }
                    
                    Button(action: {
                        if isAvailable {
                            addToCartAction()
                        }
                    }) {
                        HStack {
                            if isInCart {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(isInCart ? "Added" : "Add to Cart")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(isInCart ? Color.green.opacity(0.25) : (isAvailable ? Color.blue.opacity(0.25) : Color.gray.opacity(0.25)))
                        .foregroundColor(isInCart ? .green : (isAvailable ? .blue : .gray))
                        .cornerRadius(8)
                        .animation(.easeInOut(duration: 0.2), value: isInCart)
                    }
                    .disabled(!isAvailable)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedItem = ProductItem(
                        imageName: imageName,
                        itemName: itemName,
                        itemCost: itemCost,
                        isAvailable: isAvailable
                    )
                }
            }
            
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        ItemRowView(
            imageName: "pizza",
            itemName: "Margherita Pizza",
            itemCost: 249,
            isAvailable: true,
            selectedItem: .constant(nil),
            isInCart: false,
            addToCartAction: {}
        )
    }
    .padding()
    .background(Color.black)
}
