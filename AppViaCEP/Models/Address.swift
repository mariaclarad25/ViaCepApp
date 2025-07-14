//
//  Address.swift
//  AppViaCEP
//
//  Created by Maria Clara Dias on 10/07/25.
//

import Foundation

struct Address: Codable {
    let cep: String
    let logradouro: String
    let bairro: String
    let localidade: String
    let uf: String
    let erro: Bool?
}
