//
//  ViewController.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // suppress separators for empty rows
        
        if PokemonStore.allPokemon.isEmpty {
            activityIndicatorView.startAnimating()
            loadDecodeStorePokemon { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
//        NetworkLoader.loadAllPokemon { (allPokemon, errorMsg) in
//            if let allPokemon = allPokemon,
//                let decodedPokemon = PokemonDecoder.decode(data: allPokemon) {
//                PokemonStore.allPokemon = decodedPokemon
//            }
//            if let errorMsg = errorMsg {
//                // TODO: inform user
//                print("Network error: \(errorMsg)")
//            }
//        }
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PokemonStore.allPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let pokemonName = PokemonStore.sortedPokemonNames[indexPath.row]
        
        cell.textLabel!.text = pokemonName
        return cell
    }
}

extension ViewController {
    private func loadDecodeStorePokemon(completion: @escaping ()->()) {
        // Fetch
        NetworkLoader.loadAllPokemon { (allPokemon, errorMsg) in
            guard errorMsg == nil else {
                // TODO: inform user
                print("Network error: \(errorMsg!)"); return
            }
            // Decode
            guard let allPokemon = allPokemon,
                let decodedPokemon = PokemonDecoder.decode(data: allPokemon) else {
                    print("No results? Decoding error?"); return }
            
            // TODO: debugging-remove
            if let results = String(data: allPokemon, encoding: .utf8) {
                print(results)
            }
            // Save
            PokemonStore.allPokemon = decodedPokemon
            completion()
        }
    }
}

