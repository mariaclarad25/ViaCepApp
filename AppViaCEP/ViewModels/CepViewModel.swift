//
//  CepViewModel.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 07/07/25.
//

import Foundation

class CepViewModel: ObservableObject {
    
    @Published var cepTyped: String = "" {
        didSet {
            let numbers = cepTyped.filter {$0.isNumber}
            let characterLimit = String(numbers.prefix(8))
            let formatted = formattingCEP(characterLimit)
            
            if cepTyped != formatted {
               cepTyped = formatted
            }
        }
    }
    func formattingCEP(_ text: String) -> String {
        let numbers = text.filter { $0.isNumber }
            let part1 = numbers.prefix(5)
            let part2 = numbers.suffix(3)
            return "\(part1)-\(part2)"
    }
}
