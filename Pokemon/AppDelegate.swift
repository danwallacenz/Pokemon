//
//  AppDelegate.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        UISearchBar.appearance().barTintColor = .pokemonPurple
        UISearchBar.appearance().tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .pokemonPurple
        
        return true
    }

    // MARK: - Split view
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.pokemonID == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
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

