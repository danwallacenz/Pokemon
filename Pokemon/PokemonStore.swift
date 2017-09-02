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
            return defaults.url(forKey: "baseURL") 
        }
        set {
            defaults.set(newValue, forKey: "baseURL")
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
        return allPokemon[pokemonName]?["id"]
    }
    
    /// Experimental - could use this for a sectioned, indexed UITableView.
    /// For example,
    /// [..., ["X": ["Xatu", "Xerneas"]],
    /// ["Y": ["Yamask", "Yanma", "Yanmega", "Yveltal"]],
    /// ["Z": ["Zangoose", "Zapdos", "Zebstrika", "Zekrom", "Zigzagoon", "Zoroark", "Zorua", "Zubat", "Zweilous", "Zygarde"]]]
    static func sortedPokemonDictionary() -> [[String: [String]]] {
        let groupedPokemon = Dictionary(grouping: PokemonStore.allPokemon.keys){ String($0.characters.first!) }
        let sortedGroupedPokemon = groupedPokemon.mapValues { $0.sorted() }
        let firstCharsSortedDict = sortedGroupedPokemon.map{ [String($0.key): $0.value]  }
        
        let result = firstCharsSortedDict.sorted { (a, b) in
            a.keys.first! < b.keys.first!
        }
        return result
    }
}
