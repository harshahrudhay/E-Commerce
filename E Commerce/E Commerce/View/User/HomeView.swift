//
//  HomeView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 10/10/25.
//



import SwiftUI

struct HomeView: View {
    
    @ObservedObject var loginVM: LoginVM
    @StateObject var itemsVM = ItemsVM()
    
    @State private var searchText = ""
    @State private var showAccountSettings = false
    @State private var selectedItem: ProductItem? = nil
    @State private var navigateToOrders = false
    @State private var showToast = false   
    
    var filteredItems: [ProductItem] {
        if searchText.isEmpty {
            return itemsVM.items
        } else {
            return itemsVM.items.filter { $0.itemName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            TabView {
                
                ZStack {
                    LinearGradient(
                        colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        topHStack()
                        
                        searchBar
                        
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredItems) { item in
                                    
                                    ItemRowView(
                                        imageName: item.imageName,
                                        itemName: item.itemName,
                                        itemCost: item.itemCost,
                                        isAvailable: item.isAvailable,
                                        selectedItem: $selectedItem,
                                        isInCart: itemsVM.cartItems.contains(where: { $0.itemName == item.itemName }),
                                        addToCartAction: {
                                            if itemsVM.cartItems.contains(where: { $0.itemName == item.itemName }) {
                                                itemsVM.removeFromCart(item)
                                            } else {
                                                itemsVM.addToCart(item)
                                                showAddedToCartToast()
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    
                    if let selectedItem = selectedItem {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .blur(radius: 5)
                            .onTapGesture { self.selectedItem = nil }
                        
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                Button(action: { self.selectedItem = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                            }
                            
                            Image(selectedItem.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(20)
                                .shadow(radius: 5)
                            
                            Text(selectedItem.itemName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text("₹\(String(format: "%.2f", selectedItem.itemCost))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            if !selectedItem.isAvailable {
                                Text("Out of Stock")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                            }
                            
                            Text("A delicious and freshly prepared \(selectedItem.itemName.lowercased()) made with high-quality ingredients.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                        .padding()
                        .transition(.opacity.combined(with: .scale))
                        .zIndex(1)
                    }
                    
                    if showToast {
                        VStack {
                            Spacer()
                            Text("Added to cart")
                                .font(.subheadline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .glassEffect(.clear)
//                                .background(.ultraThinMaterial, in: Capsule())
                                .shadow(radius: 5)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .padding(.bottom, 30)
                        }
                        .zIndex(2)
                    }
                    
                    NavigationLink(
                        destination: OrderView().environmentObject(itemsVM),
                        isActive: $navigateToOrders
                    ) { EmptyView() }
                    
                    NavigationLink(
                        destination: AccountSettingsView(loginVM: loginVM),
                        isActive: $showAccountSettings
                    ) { EmptyView() }
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                CartView(loginVM: loginVM)
                    .environmentObject(itemsVM)
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    private func showAddedToCartToast() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
    
    private func topHStack() -> some View {
        HStack(spacing: 12) {
            
            Button(action: { showAccountSettings = true }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 45, height: 45)
                        .shadow(radius: 3)
                    Text(loginVM.username.isEmpty ? "U" : String(loginVM.username.prefix(1)).uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.glass)
            
            VStack(alignment: .leading) {
                Text("Welcome, \(loginVM.username.isEmpty ? "User" : loginVM.username)")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search items...", text: $searchText)
        }
        .padding()
        .glassEffect(.clear.interactive())
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    let vm = LoginVM()
    vm.username = "Harsha"
    return HomeView(loginVM: vm)
}
