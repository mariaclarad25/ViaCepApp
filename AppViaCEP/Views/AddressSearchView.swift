//
//  AddressSearchView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 17/07/25.
//

import SwiftUI

struct AddressSearchView: View {
    
    @StateObject private var viewModelAddress = AddressViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                if viewModelAddress.address.isEmpty {
                    
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color(.colorBlue))
                        .padding(.top, 40)
                    
                    Text("Digite seu endereço:")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.blueDark))
                    
                    TextField("Localidade/UF", text: $viewModelAddress.uf)
                        .styleTextField()
                        .autocorrectionDisabled(true) //desliga autocorreção
                        .textInputAutocapitalization(.characters)
                        .onChange(of: viewModelAddress.uf) {_, newValue in
                            if newValue.count > 2 {
                                viewModelAddress.uf = String(newValue.prefix(2))
                            }
                        }
                    
                    TextField("Cidade", text: $viewModelAddress.city)
                        .styleTextField()
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Rua", text: $viewModelAddress.road)
                        .styleTextField()
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                    
                    if let errorMessage = viewModelAddress.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    if viewModelAddress.isLoading {
                        ProgressView()
                    } else {
                        Button(action: {
                            Task {
                                await viewModelAddress.searchAddress()
                            }
                        }, label: {
                            Text("Buscar")
                        })
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.colorBlue)
                        .cornerRadius(8)
                        
                    }
                }
                
                if !viewModelAddress.address.isEmpty {
                    Text("Resultados")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                        .foregroundColor(Color(.blueDark))
                    
                    ForEach(viewModelAddress.address, id: \.cep) { address in
                        AddressCardView(address: address)
                    }
                    
                    // MARK: - IBGE
                    if let address = viewModelAddress.address.first,
                       let ibgeURL = viewModelAddress.getIBGEURL(for: address) {
                        
                        Link(destination: ibgeURL) {
                            Text("Ver mais sobre \(address.localidade) no IBGE")
                                .font(.body)
                                .foregroundColor(.blue)
                                .padding(.top, 3)
                        }
                    }
                    //
                    if !viewModelAddress.address.isEmpty || viewModelAddress.errorMessage != nil {
                        Button(action: {
                            viewModelAddress.clearFields()
                        }) {
                            Label ("Nova busca", systemImage: "arrow.clockwise")
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.blueDark))
                        .padding(.bottom, 20)
                    }
                }
            }
            .padding()
        }
    }
}

extension View {
    func styleTextField() -> some View {
        self
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(.black)
    }
}

#Preview {
    AddressSearchView()
}
