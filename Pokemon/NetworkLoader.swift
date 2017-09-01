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
                    print("Error: \(error)")
                    
                } else if let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let data = data {
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                }
//                    let results = String(data: data, encoding: .utf8) {
//                        print("Response: \(response)")
//                        print("DATA:\n\(results)\nEND DATA\n")
//                        completion(results)
            }).resume()
        }
    }
    
    static func loadPokemon(withId id: String) {
        
    }
    
}
