//
//  PokemonDecoder.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation

struct PokemonDecoder {
    
    static func decodeCount(from data: Data) -> Int? {
        let json = JSON(data: data)
        guard let rawCount = json["count"].rawValue as? Int else { return nil }
        return rawCount
    }
    
    static func decode(data: Data) -> (baseURL: URL, data: [String: [String: String]])? {
       
        // Extract the payload
        let json = JSON(data: data)
        guard let results = json.dictionaryObject?["results"] as? [[String : String]] else { return nil }
        
        // Extract base URL
        guard let baseURL = extractBaseURL(from: results) else { return nil }
        
        // Convert [["name": "pikachu-pop-star", "url": "https://pokeapi.co/api/v2/pokemon/10082/"], ...] -> [["Pikachu-Pop-Star": ["id": "10082"], ...]
        var dict: [String: [String: String]] = [:]
        for pokemon in results {
            guard let name = pokemon["name"],
                let urlString = pokemon["url"],
                let url = URL(string: urlString),
                let id = url.pathComponents.last else { continue }
            let contents = ["id": id]
            dict[name.capitalized] = contents
        }
        return (baseURL: baseURL, data: dict)
    }
    
    private static func extractBaseURL(from data: [[String : String]]) -> URL? {
        guard let first = data.first,
            let urlString = first["url"],
            let url = URL(string: urlString) else { return nil }
        return url.deletingLastPathComponent() // remove id
    }
    
    /// Decode from network fetch
    static func decodePokemon(data: Data) -> Pokemon? {
        // Extract the payload
        let json = JSON(data: data)
        
        guard let dict = json.dictionaryObject else { return nil }
        guard let id = dict["id"] as? Int else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let weight = dict["weight"] as? Int else { return nil }
        guard let height = dict["height"] as? Int else { return nil }
        // uglee
        var spriteDict = [String: URL]()
        if let sprites = dict["sprites"] as? [String: Any] {
            for key in sprites.keys {
                if let urlString = sprites[key] as? String,
                    let url = URL(string: urlString) {
                    spriteDict[key] = url
                }
            }
        }
        let pokemon = Pokemon(id: String(id), name: name.capitalized, weight: weight, height: height, images: spriteDict)
        return pokemon
    }
    
    /// Serialize Pokemon for storage
    static func encode(pokemon: Pokemon) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(pokemon)
    }
    
    /// Deserialize Pokemon from storage
    static func decode(pokemon json: Data) -> Pokemon? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Pokemon.self, from: json)
    }
}
