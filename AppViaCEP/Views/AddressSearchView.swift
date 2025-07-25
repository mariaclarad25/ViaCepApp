//
//  AddressSearchView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 17/07/25.
//

import SwiftUI

struct AddressSearchView: View {
    
    @StateObject private var viewModelAddress = AddressViewModel()
    
    @FocusState private var focusedField: Field?

    private enum Field {
        case uf, city, road
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                
                if viewModelAddress.address.isEmpty {
                    
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color(.colorBlue))
                        .padding(.top, 30)
                    
                    Text("Digite seu endereço:")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.blueDark))
                    
                    TextField("UF", text: $viewModelAddress.uf)
                        .styleTextField()
                        .autocorrectionDisabled(true) //desliga autocorreção
                        .textInputAutocapitalization(.characters)
                        .focused($focusedField, equals: .uf)
                        .onChange(of: viewModelAddress.uf) {_, newValue in
                            if newValue.count > 2 {
                                viewModelAddress.uf = String(newValue.prefix(2))
                            }
                        }
                    
                    TextField("Cidade", text: $viewModelAddress.city)
                        .styleTextField()
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .city)
                    
                    TextField("Rua", text: $viewModelAddress.road)
                        .styleTextField()
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.words)
                        .focused($focusedField, equals: .road)
                    
                    if let errorMessage = viewModelAddress.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                }
                
                if !viewModelAddress.address.isEmpty {
                    Text("Resultados")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.blueDark))
                        .padding(.top, 8)
                    
                    let bairros = viewModelAddress.address.map { $0.bairro }
                    //cria lista dos bairros e remove os duplicados para fazer verificação
                    if bairros.count != Set(bairros).count {
                        Text("Este endereço possui mais de um CEP no mesmo bairro. O número da residência pode influenciar no CEP correto.")
                            .font(.footnote)
                            .foregroundColor(Color(.colorOrange))
                            .multilineTextAlignment(.center)
                    }
                    
                    ForEach(viewModelAddress.address, id: \.cep) { address in
                        AddressCardView(address: address)
                    }
                    
                    if let address = viewModelAddress.address.first,
                       let ibgeURL = viewModelAddress.getIBGEURL(for: address) {
                        
                        Link(destination: ibgeURL) {
                            Text("Ver mais sobre \(address.localidade) no IBGE")
                                .font(.body)
                                .foregroundColor(.blue)
                                .padding(.top, 3)
                        }
                    }
                    
                    if !viewModelAddress.address.isEmpty {
                        Button(action: {
                            viewModelAddress.clearFields()
                        }) {
                            Label ("Nova busca", systemImage: "arrow.clockwise")
                        }
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.blueDark))
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        
        .safeAreaInset(edge: .bottom) {
            VStack{
                if viewModelAddress.isLoading {
                    ProgressView()
                } else if viewModelAddress.address.isEmpty {
                    Button(action: {
                        Task {
                            focusedField = nil
                            await viewModelAddress.searchAddress()
                        }
                    }) {
                        Text("Buscar")
                            .styleButton()
                            .styleGradientBlue()
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom)
        }
        .padding()
        
        .navigationBarBackButtonHidden(!viewModelAddress.address.isEmpty) //esconde botão padrão
        .toolbar {
            if !viewModelAddress.address.isEmpty {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        viewModelAddress.clearFields()
                    }) {
                        Image(systemName: "arrow.left")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.blueDark))
                    }
                }
            }
        }
    }
}

#Preview {
    AddressSearchView()
}
