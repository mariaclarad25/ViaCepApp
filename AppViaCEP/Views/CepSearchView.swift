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
            
            TextField("00000-000", text: $viewModel.cepTyped)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.black)
                .padding(.bottom, 35)
            //executa a ação quando a variável muda - filtra e limita
                .onChange(of: viewModel.cepTyped) { _, newValue in
                    let filtered = newValue.filter { "0123456789".contains($0)}
                    if filtered.count > 8 {
                        viewModel.cepTyped = String(filtered.prefix(8))
                    } else {
                        viewModel.cepTyped = filtered
                    }
                }
            
            Button(action: {
                viewModel.searchCEP()
            }, label: {
                Text("Buscar")
            })
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.colorBlue)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CepSearchView()
}
