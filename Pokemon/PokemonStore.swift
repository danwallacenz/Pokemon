//
//  PokemonStore.swift
//  Pokemon
//
//  Created by Daniel Wallace on 31/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation

class PokemonStore {
    
    private static let defaults = UserDefaults.standard

    static var _inMemoryCache = [String: [String: String]]() // Not private for testing

    static var sortedPokemonNames: [String] {
        return allPokemon.keys.sorted()
    }
    
    static var baseURL: URL? {
        get {
            let urlString = defaults.value(forKey: "baseURL") as? String
            return URL.init(string: urlString ?? "error")
        }
        set {
            let urlString = newValue?.absoluteString
            defaults.set(urlString, forKey: "baseURL")
        }
    }
    
    static var allPokemon: [String: [String: String]] {
        get {
            if _inMemoryCache.isEmpty {
                guard let all = defaults.value(forKey: "all") as? [String: [String: String]] else { return [:] }
                _inMemoryCache = all
            }
            return _inMemoryCache
        }
        set {
            defaults.set(newValue, forKey: "all")
            _inMemoryCache = defaults.value(forKey: "all") as? [String: [String: String]] ?? [:]
        }
    }
    
    static func id(for pokemonName: String) -> String? {
        return _inMemoryCache[pokemonName]?["id"]
    }
}
