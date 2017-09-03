//
//  NetworkLoader.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation
import UIKit

class NetworkLoader {
    
    private static let session: URLSession = {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.timeoutIntervalForRequest = 10
        return URLSession(configuration: defaultConfiguration)
    }()
    
    static func loadAllPokemon(completion: @escaping (Data?, String?) -> ()) {

            if var urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon") {
                urlComponents.query = "limit=1000&offset=0"
                guard let url = urlComponents.url else { return }
                
            (session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(nil, error.localizedDescription)
                    }
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
        
        (session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data {
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }).resume()
    }
    
    static func loadImage(fromURL url: URL, completion: @escaping (UIImage?, String?) -> ()) {
        
        (session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            }
        }).resume()
    }
}
