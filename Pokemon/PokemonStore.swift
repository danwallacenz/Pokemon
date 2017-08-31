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
    static var _inMemoryCache = [[String: String]]()

    static var allPokemon: [[String: String]] {
        get {
            if _inMemoryCache.isEmpty {
                guard let all = defaults.value(forKey: "all") as? [[String: String]] else { return [] }
                _inMemoryCache = all
            }
            return _inMemoryCache
        }
        set {
            defaults.set(newValue, forKey: "all")
            _inMemoryCache = defaults.value(forKey: "all") as? [[String: String]] ?? []
        }
    }
}
