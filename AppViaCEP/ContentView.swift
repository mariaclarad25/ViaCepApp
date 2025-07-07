//
//  ContentView.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 07/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("App ViaCEP iniciado com sucesso!")
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
            
            Image(systemName: "map")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(.colorBlue))
                .padding()
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
