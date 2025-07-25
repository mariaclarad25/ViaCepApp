//
//  InitialView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 15/07/25.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("logo_map")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                
                Text("Bem-vindo ao Wayfind")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorBlue)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: CepSearchView()){
                    Text ("Busque por CEP")
                        .styleButton()
                        .styleGradientBlue()
                        .cornerRadius(6)
                }
                
                NavigationLink(destination: AddressSearchView()){
                    Text("Busque por endereço")
                        .styleButton()
                        .styleGradientBlue()
                        .cornerRadius(6)
                }
                
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.white, Color(.systemBlue).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Wayfind")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.colorBlue), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .tint(Color(.blueDark))
    }
}

#Preview {
    InitialView()
}
