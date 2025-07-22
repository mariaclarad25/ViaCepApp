//
//  ContentView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 07/07/25.
//

import SwiftUI

struct CepSearchView: View {
    
    @StateObject private var viewModel = CepViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            
            Image(systemName: "map")
                .resizable()
                .frame(width: 75, height: 75)
                .foregroundColor(Color(.colorBlue))
                .padding(.top, 40)
            
            Text("Digite seu CEP:")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.blueDark))
            
            TextField("00000-000", text: $viewModel.cepTyped)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.black)
            //executa a ação quando a variável muda - filtra e limita
                .onChange(of: viewModel.cepTyped) { _, newValue in
                    let filtered = newValue.filter { "0123456789".contains($0)}
                    if filtered.count > 8 {
                        viewModel.cepTyped = String(filtered.prefix(8))
                    } else {
                        viewModel.cepTyped = filtered
                    }
                }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                Task {
                    await viewModel.searchCEP()
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
            
            if let address = viewModel.address {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "house.fill")
                            .foregroundColor(.blue)
                        Text("Rua: \(address.logradouro)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        Text("Bairro: \(address.bairro)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.green)
                        Text("Cidade: \(address.localidade)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.orange)
                        Text("UF: \(address.uf)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            
        // MARK: - IBGE
            if let address = viewModel.address,
               let ibgeURL = viewModel.getIBGEURL(for: address) {
                Link("Ver mais sobre \(address.localidade) no IBGE",
                     destination: ibgeURL)
                    .font(.body)
                    .foregroundColor(.blue)
                    .padding(.top, 3)
            }
        //
            if viewModel.address != nil {
                Button(action: {
                    viewModel.clearFields()
                }) {
                    Label ("Nova busca", systemImage: "arrow.clockwise")
                }
                .font(.headline)
                .foregroundColor(Color(.blueDark))
                .padding(.top, 12)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CepSearchView()
}
