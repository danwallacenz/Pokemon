//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UISearchBar.appearance().barTintColor = .pokemonPurple
        UISearchBar.appearance().tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .pokemonPurple
        
        return true
    }
}

extension UIColor {
    static let pokemonPurple = UIColor(red: 180.0/255.0, green: 105.0/255.0, blue: 181.0/255.0, alpha: 1.0)
}

//
//    private func loadDecodeStorePokemon() {
//        NetworkLoader.loadAllPokemon { (allPokemon, errorMsg) in
//            guard errorMsg == nil else {
//                // TODO: inform user
//                print("Network error: \(errorMsg!)"); return
//            }
//            guard let allPokemon = allPokemon,
//                let decodedPokemon = PokemonDecoder.decode(data: allPokemon) else {
//                    print("No results? Decoding error?"); return }
//
//            // TODO: debugging-remove
//            if let results = String(data: allPokemon, encoding: .utf8) {
//                print(results)
//            }
//            PokemonStore.allPokemon = decodedPokemon
//        }
//    }
//}

