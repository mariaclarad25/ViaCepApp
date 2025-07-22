//
//  AddressViewModel.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 17/07/25.
//

import Foundation

@MainActor
final class AddressViewModel: ObservableObject {
    
    @Published var uf: String = ""
    @Published var city: String = ""
    @Published var road: String = ""
    @Published var address: [Address] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func validateFields() -> Bool {
        let ufTrimmed = uf.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityTrimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let roadTrimmed = road.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !ufTrimmed.isEmpty && !cityTrimmed.isEmpty && !roadTrimmed.isEmpty
    }
    
    func searchAddress() async {
        guard validateFields() else {
            handleError("Preencha todos os campos corretamente.")
            return
        }
        resetState()
        
        do {
            let results = try await requestFetchCEP()
            self.address = results
            self.isLoading = false
            
        } catch {
            handleError("Erro ao buscar o endereço: \(error.localizedDescription)")
        }
    }
    
    func requestFetchCEP() async throws -> [Address] {
        let ufFormatted = uf
            .uppercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let cityFormatted = city
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let roadFormatted = road
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //codifica para url
        
        guard let url = URL(string: "https://viacep.com.br/ws/\(ufFormatted)/\(cityFormatted)/\(roadFormatted)/json/") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode([Address].self, from: data)
        
        if decoded.isEmpty {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Endereço não encontrado."])
        }
        return decoded
    }
    
    func clearFields() {
        uf = ""
        city = ""
        road = ""
        address = []
        errorMessage = nil
    }
    
    private func resetState() {
        self.errorMessage = nil
        self.address = []
        self.isLoading = true
    }
    
    private func handleError(_ message: String) {
        self.errorMessage = message
        self.address = []
        self.isLoading = false
        
    }
    
    func getIBGEURL(for address: Address) -> URL? {
        let cidade = address.localidade
            .folding(options: .diacriticInsensitive, locale: .current) //remove acento e cedilha
            .lowercased() //letra minuscula
            .replacingOccurrences(of: " ", with: "-")
        
        let uf = address.uf.lowercased()
        let urlString = "https://cidades.ibge.gov.br/brasil/\(uf)/\(cidade)/panorama"
        
        return URL(string: urlString)
    }
}
