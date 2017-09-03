//
//  DetailViewController.swift
//  Pokemon
//
//  Created by Daniel Wallace on 2/09/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {

    @IBOutlet weak var heightTitleLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightTitleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var pokemonID: String? {
        didSet{
            guard let pokemonID = pokemonID else { fatalError() }
            loadPokemon(withID: pokemonID)
        }
    }
    var pokemon: Pokemon?
    
    private func loadPokemon(withID id: String) {
        NetworkLoader.loadPokemon(withId: id) { [weak self] (pokemonData, errorMsg) in
            
            if let errorMsg = errorMsg {
                print(errorMsg); return
            }
            guard let pokemonData = pokemonData, let strongSelf = self, let pokemon = PokemonDecoder.decodePokemon(data: pokemonData) else { return }
            
            strongSelf.pokemon = pokemon
            strongSelf.updateUI()
        }
    }
    
    private func updateUI() {
        guard let pokemon = pokemon else { return }
        
        title = pokemon.name
        heightLabel.text = String(pokemon.height)
        weightLabel.text = String(pokemon.weight)
        
        // images
        let images = pokemon.images
        guard images.count > 0 else {
            activityIndicatorView.stopAnimating()
            setHidden(false) // no more data
            return
        }
        // Could have an animated image with these ...
        var imageCount = 0
        for key in images.keys {
            guard let imageURL = images[key] else { continue }
            NetworkLoader.loadImage(fromURL: imageURL) { [weak self] (image, errorMsg) in
                guard let strongSelf = self else { return }
                if errorMsg != nil {
                    print(errorMsg!)
                } else {
                    if let image = image {
                        strongSelf.pokemon?.addPNG(for: key, image: image)
                        strongSelf.imageView.image = image
                        imageCount += 1
                        if imageCount == images.keys.count {
                            // all loaded
                            strongSelf.testCodable()
                        }
                    }
                    strongSelf.activityIndicatorView.stopAnimating()
                    strongSelf.setHidden(false) // we have enough data
                }
            }
        }
    }
    
    private func testCodable() {
//        let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // decoding our data
        var plist: Data?
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            plist = try encoder.encode(pokemon)
        } catch {
            print("error")
        }
        guard plist != nil else { print("no plist"); return }
        print("\(plist!)")
        let str = String(data: plist!, encoding: .utf8)
        print(str ?? "Not there")
        print()
        // decode
        let decoder = PropertyListDecoder()
        let pokemonDecoded: Pokemon?
        do {
            pokemonDecoded = try decoder.decode(Pokemon.self, from: plist!)
            guard let pokemonDecoded2 = pokemonDecoded else { print("no pokemon2");return }
            print("\(pokemonDecoded2)")
        } catch {
            print("error decoding")
        }
//        guard let pokemonDecoded2 = pokemonDecoded else { print("no pokemon2");return }
        
        print()
        
    }
    
    private func setHidden(_ isHidden: Bool) {
        heightTitleLabel.isHidden = isHidden
        heightLabel.isHidden = isHidden
        weightTitleLabel.isHidden = isHidden
        weightLabel.isHidden = isHidden
        imageView.isHidden = isHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setHidden(true)
        if pokemonID != nil {
            activityIndicatorView.startAnimating()
        }
        super.viewWillAppear(animated)
    }
}
