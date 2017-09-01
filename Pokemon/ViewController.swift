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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        NetworkLoader.loadAllPokemon { (allPokemon, errorMsg) in
            if let allPokemon = allPokemon,
                let decodedPokemon = PokemonDecoder.decode(data: allPokemon) {
                PokemonStore.allPokemon = decodedPokemon
            }
            if let errorMsg = errorMsg {
                // TODO: inform user
                print("Network error: \(errorMsg)")
            }
        }
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

        let pokemon = PokemonStore.allPokemon[indexPath.row]
        
        cell.textLabel!.text = pokemon["name"]
        return cell
    }
}

