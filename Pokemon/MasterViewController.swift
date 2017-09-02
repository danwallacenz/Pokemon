//
//  ViewController.swift
//  Pokemon
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPokemon = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // suppress separators for empty rows
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        if PokemonStore.allPokemon.isEmpty {
            activityIndicatorView.startAnimating()
            loadDecodeStorePokemon { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
        print(PokemonStore.allPokemon) // TODO: remove
        print()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPokemon.count
        }
        return PokemonStore.sortedPokemonNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let pokemonName: String
        if isFiltering() {
            pokemonName = filteredPokemon[indexPath.row]
        } else {
            pokemonName = PokemonStore.sortedPokemonNames[indexPath.row]
        }
        
        cell.textLabel!.text = pokemonName
        return cell
    }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //guard let row = self.tableView.indexPathForSelectedRow?.row else { fatalError() }
        guard let detailVC = segue.destination as? DetailViewController else { fatalError() }
        guard let cell = sender as? UITableViewCell else { fatalError() }
        guard let selectedPokemonName = cell.textLabel?.text else { fatalError() }
        guard let selectedPokemonID = PokemonStore.id(for: selectedPokemonName) else { fatalError() }
        
        detailVC.pokemonID = selectedPokemonID
     }
}

// TODO: Move to a controller object
extension MasterViewController {
    private func loadDecodeStorePokemon(completion: @escaping ()->()) {
        // Fetch
        NetworkLoader.loadAllPokemon { (allPokemon, errorMsg) in
            guard errorMsg == nil else {
                // TODO: inform user
                print("Network error: \(errorMsg!)"); return
            }
            // Decode
            guard let allPokemon = allPokemon,
                let decodedData = PokemonDecoder.decode2(data: allPokemon)
            else { print("No results? Decoding error?"); return }
            
            // TODO: debugging-remove
            if let results = String(data: allPokemon, encoding: .utf8) {
                print(results)
            }
           
            // Save data
            let pokemonData = decodedData.data
            PokemonStore.allPokemon = pokemonData
            
            // Save baseURL
            let baseUrL = decodedData.baseURL
            PokemonStore.baseURL = baseUrL
            
            completion()
        }
    }
}

extension MasterViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension MasterViewController {
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPokemon = PokemonStore.sortedPokemonNames.filter {
            $0.lowercased().starts(with: searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

