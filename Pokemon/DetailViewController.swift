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
        loadImageData(from: images) { [weak self] pngs in
            guard let _/*strongSelf*/ = self else { return }
            // We have all the images now ... animated image?
            
        }
    }
    
    private func loadImageData(from images: [String : URL], completion: @escaping ([UIImage]?) -> ()) {
        var imageCount = 0
        for key in images.keys {
            guard let imageURL = images[key] else { continue }
            NetworkLoader.loadImage(fromURL: imageURL) { [weak self] (image, errorMsg) in
                guard let strongSelf = self else { return }
                if errorMsg != nil {
                    print(errorMsg!)
                } else {
                    if let image = image {
                        strongSelf.pokemon?.addPNG(image: image)
                        strongSelf.imageView.image = image // will usually show several
                        imageCount += 1
                        if imageCount == images.keys.count {
                            // all loaded
                            completion(strongSelf.pokemon?.pngs)
                        }
                    }
                    strongSelf.activityIndicatorView.stopAnimating()
                    strongSelf.setHidden(false) // we have enough data
                }
            }
        }
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
