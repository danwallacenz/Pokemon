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
    var detailViewController: DetailViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPokemon = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // suppress separators for empty rows
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        // Load data first time. TODO: What about new data?
        if PokemonStore.allPokemon.isEmpty {
            activityIndicatorView.startAnimating()
            loadDecodeStorePokemon { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        super.viewWillAppear(animated)
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

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let detailNavVC = segue.destination as? UINavigationController, let detailVC = detailNavVC.topViewController as? DetailViewController else { fatalError() }
        guard let cell = sender as? UITableViewCell else { fatalError() }
        // Storing data in cell is not so great!
        guard let selectedPokemonName = cell.textLabel?.text else { fatalError() }
        guard let selectedPokemonID = PokemonStore.id(for: selectedPokemonName) else { fatalError() }
        
        detailVC.pokemonID = selectedPokemonID
        
        detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        detailVC.navigationItem.leftItemsSupplementBackButton = true
     }
}

// TODO: Move to a controller object?
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
                let decodedData = PokemonDecoder.decode(data: allPokemon)
            else { print("No results? Decoding error?"); return }
           
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
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension MasterViewController {
    
    func searchBarIsEmpty() -> Bool {
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

