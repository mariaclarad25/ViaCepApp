//
//  CepViewModel.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 07/07/25.
//

import Foundation

@MainActor
final class CepViewModel: ObservableObject {
    
    @Published var cepTyped: String = ""
    @Published var address: Address?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
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
    
    func searchCEP() async {
        if validCEP() {
            errorMessage = nil
            address = nil
            isLoading = true
            
            let cleanCEP = cepTyped.filter { $0.isNumber }
            cepTyped = formattingCEP(cleanCEP)
            
            do {
                let result = try await requestFetchAddress(for: cleanCEP)
                address = result
            } catch {
                errorMessage = "Erro ao buscar o CEP: \(error.localizedDescription)"
            }
            
            isLoading = false
        } else {
            errorMessage = "CEP inválido. Digite 8 números."
            address = nil
        }
    }
    
    private func requestFetchAddress(for cep: String) async throws -> Address {
        guard let url = URL(string: "https://viacep.com.br/ws/\(cep)/json/") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(Address.self, from: data)
        
        if let erro = decoded.erro, erro == true {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "CEP não encontrado."])
        }
        
        return decoded
    }
    
    func clearFields() {
        cepTyped = ""
        address = nil
        errorMessage = nil
    }
    
    func getIBGEURL(for address: Address) -> URL? {
        let cidade = address.localidade
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
        
        let uf = address.uf.lowercased()
        let urlString = "https://cidades.ibge.gov.br/brasil/\(uf)/\(cidade)/panorama"
        
        return URL(string: urlString)
    }
}
