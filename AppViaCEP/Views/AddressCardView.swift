//
//  AddressCardView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 18/07/25.
//

import SwiftUI

struct AddressCardView: View {
    let address: Address
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "location.viewfinder")
                    .foregroundColor(.blue)
                Text("CEP: \(address.cep)")
                    .font(.body)
                    .fontWeight(.semibold)
            }
            Text(address.logradouro)
                .font(.headline)
            Text("\(address.bairro), \(address.localidade) - \(address.uf)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    AddressCardView(address: Address(cep: "12345-678", logradouro: "Rua Exemplo", bairro: "Centro", localidade: "São Paulo", uf: "SP", erro: false))
}

