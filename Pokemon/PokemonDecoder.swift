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
    
    /// Convert a Data blob into an Array of ["name": String, "id": String(Int)] if possible.
    ///
    /// - Parameter data: Downloaded data
    /// - Returns: [["name": String, "id": String(Int)]]?
//    static func decode(data: Data) -> [String: String]? {
//        let json = JSON(data: data)
//        // Extract the payload
//        guard let results = json.dictionaryObject?["results"] as? [[String : String]] else { return nil }
//        // We'll end up with an Array of [String<name>:  String(Int)<id>]
//        let names = results.flatMap({ dict -> (name: String, id: String)? in
//            if let name = dict["name"], let urlString = dict["url"], let url = URL(string: urlString) {
//                return (name: name.capitalized, id: url.pathComponents.last ?? "?")
//            }
//            return nil
//        })
//        var dict: [String: String] = [:]
//        for pokemon in names {
//            dict[pokemon.name] = pokemon.id
//        }
//        return dict
//    }
    
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
    
    static func decodePokemon(data: Data) -> Pokemon? {
        // Extract the payload
        let json = JSON(data: data)
        guard let dict = json.dictionaryObject else { return nil }
        guard let id = dict["id"] as? Int else { return nil }
        guard let name = dict["name"] as? String else { return nil }
        guard let weight = dict["weight"] as? Int else { return nil }
        guard let height = dict["height"] as? Int else { return nil }
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
}
