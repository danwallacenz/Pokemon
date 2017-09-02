//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Daniel Wallace on 2/09/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var pokemonID: String? {
        didSet{
            print("My pokemon has ID \(String(describing: pokemonID))")
            guard let pokemonID = pokemonID else { fatalError() }
            loadPokemon(withID: pokemonID)
        }
    }
    
    private func loadPokemon(withID id: String) {
        NetworkLoader.loadPokemon(withId: id) { (pokemonData, errorMsg) in
            if let errorMsg = errorMsg {
                print(errorMsg); return
            }
            guard let pokemonData = pokemonData else { return }
            // TODO: debugging-remove
            if let results = String(data: pokemonData, encoding: .utf8) {
                print(results)
            }
            print()
            PokemonDecoder.decodePokemon(data: pokemonData)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
