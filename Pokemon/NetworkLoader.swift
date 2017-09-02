//
//  NetworkLoader.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation

class NetworkLoader {
    
    static func loadAllPokemon(completion: @escaping (Data?, String?) -> ()) {

            if var urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon") {
                urlComponents.query = "limit=1000&offset=0"
                guard let url = urlComponents.url else { return }
            
            (URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil, error.localizedDescription)
                } else if let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data {
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                }
            }).resume()
        }
    }
    
    static func loadPokemon(withId id: String, completion: @escaping (Data?, String?) -> ()) {
        
        guard let baseURL = PokemonStore.baseURL else { fatalError() }
        let url = baseURL.appendingPathComponent("\(id)/")
        
        (URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error.localizedDescription)
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data {
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }).resume()
    }
    
}
