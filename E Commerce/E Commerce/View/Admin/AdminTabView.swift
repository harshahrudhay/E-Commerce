//
//  AdminTabView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//



import SwiftUI

struct AdminTabView: View {
    @ObservedObject var loginVM: LoginVM   
    @State private var selectedTab = 1

    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            AddProductView()
                .tag(0)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add Product")
                }

            AdminOrdersView()
                .tag(1)
                .tabItem {
                    Image(systemName: "cart")
                    Text("Orders")
                }
            
            AdminItemsView()
                .tag(2)
                .tabItem {
                    Image(systemName: "receipt")
                    Text("Items")
                }
            
            AdminProfileView(loginVM: loginVM)
                .tag(3)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
           
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.orange)
    }
}

#Preview {
    AdminTabView(loginVM: LoginVM())
}
