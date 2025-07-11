//
//  CepViewModel.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 07/07/25.
//

import Foundation

final class CepViewModel: ObservableObject {
    
    @Published var cepTyped: String = ""
    
    func validCEP() -> Bool {
        let numbers = cepTyped.filter {$0.isNumber}
        
        if numbers.count == 8 {
            print ("CEP válido!")
            return true
        } else {
            print ("CEP inválido!")
            return false
        }
    }
    
    private func formattingCEP(_ text: String) -> String {
        let numbers = text.filter {$0.isNumber}
        
        guard numbers.count == 8 else {
            return ""
        }
        
        let part1 = numbers.prefix(5)
        let part2 = numbers.suffix(3)
        return "\(part1)-\(part2)"
    }
    
    func searchCEP() {
        if validCEP() {
            cepTyped = formattingCEP(cepTyped.filter { $0.isNumber })
            print ("Buscando: \(cepTyped)")
        } else {
            print ("Não foi possível realizar a busca.")
        }
    }
}
