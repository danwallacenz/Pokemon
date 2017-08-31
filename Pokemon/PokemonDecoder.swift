//
//  PokemonDecoder.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation

struct PokemonDecoder {
    
    static func decode(data: Data) -> [[String:String]]? {
        
        let json = JSON(data: data)
        guard let results = json.dictionaryObject?["results"] as? [[String : String]] else { return nil }
        let names = results.flatMap({ dict -> [String : String]? in
            if let name = dict["name"], let urlString = dict["url"], let url = URL(string: urlString) {
                return ["name" : name, "id": url.pathComponents.last ?? "?"] //.description
            }
            return nil
        })
        return names
    }
}
