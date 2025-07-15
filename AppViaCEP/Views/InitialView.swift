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
                
                Text("Bem-vindo ao BuscaCEP")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.colorBlue)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: CepSearchView()){
                    Text ("Começar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Color(.colorBlue), Color(.blueDark)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(6)
                }
                .padding()
                Spacer()
            }
            .background(
                LinearGradient(
                    colors: [Color.white, Color(.systemBlue).opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("BuscaCEP")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.colorBlue), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    InitialView()
}
