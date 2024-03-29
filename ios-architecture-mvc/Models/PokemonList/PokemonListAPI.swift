//
//  PokemonListAPI.swift
//  ios-architecture-mvc
//
//  Created by AIR on 2023/04/26.
//

import Foundation

protocol PokemonListAPIProtocol {
    func requestPokemonList(completion: @escaping (_ result: Result<[Pokemon], APIError>) -> Void)
}

class PokemonListAPI: PokemonListAPIProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    private let request = PokemonListAPIRequest()
    
    func requestPokemonList(completion: @escaping (Result<[Pokemon], APIError>) -> Void) {
        apiClient.request(request) { result in
            switch result {
            case .success(let data):
                let pokemonList = data.results.map { Pokemon($0) }
                completion(.success(pokemonList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct PokemonListAPIRequest: APIRequest {
    typealias ResponseType = PokemonResponse
    
    var url: String {
        return "https://pokeapi.co/api/v2/"
    }
    
    var path: String {
        return "pokemon"
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var queries: [String: String] {
        return ["limit": "1281"]
    }
    
    var timeout: TimeInterval {
        return 60
    }
    
    func decode(from data: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseType.self, from: data)
    }
}
