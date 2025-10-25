//
//  AddProductView.swift
//  MainAssessment4
//
//  Created by HarshaHrudhay on 11/10/25.
//




import SwiftUI

struct AddProductView: View {
    
    @StateObject private var addProductVM = AddProductVM()
    @Environment(\.dismiss) private var dismiss
    
    let productTypes = ["Electronics", "Groceries", "Clothes", "Essentials", "Gadgets"]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.4)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 25) {
                    
                    Text("Add New Product")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 40)
                        .shadow(radius: 10)
                    
                    textFieldText(title: "Product Name", text: $addProductVM.productName)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            Picker("Select Category", selection: $addProductVM.productType) {
                                ForEach(productTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 180)
                            .padding(10)
                            .glassEffect(.clear.interactive())
                            .cornerRadius(12)
                            .shadow(radius: 3)
                            .padding(.trailing, 20)
                        }
                    }
                    
                    textFieldText(title: "Cost", text: $addProductVM.productCost, keyboardType: .decimalPad)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        
                        TextField("Enter description", text: $addProductVM.productDescription, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(15)
                            .shadow(radius: 3)
                            .padding(.horizontal, 20)
                    }
                    
                    textFieldText(title: "Image Name (from Assets)", text: $addProductVM.imageName)
                    
                    Button(action: {
                        Task {
                            await addProductVM.addProductToRealtimeDB()
                        }
                    }) {
                        Text(addProductVM.isSaving ? "Saving..." : "Save Product")
                            .font(.headline)
                            .foregroundColor(.black
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .glassEffect(.clear.interactive())
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.horizontal, 20)
                    }
                    .disabled(addProductVM.isSaving)
                    
                    Spacer()
                }
                .padding(.bottom, 60)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(addProductVM.alertMessage, isPresented: $addProductVM.showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    @ViewBuilder
    func textFieldText(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 20)
            
            TextField("Enter \(title.lowercased())", text: text)
                .keyboardType(keyboardType)
                .padding()
                .glassEffect(.clear.interactive())
                .cornerRadius(15)
                .shadow(radius: 3)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NavigationStack {
        AddProductView()
    }
}
