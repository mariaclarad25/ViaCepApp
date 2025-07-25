//
//  Styles.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 25/07/25.
//

import SwiftUI

extension View {
    func styleTextField() -> some View {
        self
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(.black)
    }
    
    func styleGradientBlue() -> some View {
        self
            .background(
                LinearGradient(
                    colors: [Color(.colorBlue), Color(.blueDark)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
    
    func styleButton() -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
    }
}
