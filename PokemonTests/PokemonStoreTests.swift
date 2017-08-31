//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Daniel Wallace on 30/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import XCTest
@testable import Pokemon

class PokemonStoreTests: XCTestCase {
    
    private let defaults = UserDefaults.standard
    let testData = [["name": "Pokemon1", "id": "1"], ["name": "Pokemon2", "id": "2"]]
    
    override func setUp() {
        super.setUp()
        clearStore()
    }
    
    override func tearDown() {
        clearStore()
        super.tearDown()
    }
    
    private func clearStore() {
        defaults.setValue(nil, forKey: "all")
        PokemonStore._inMemoryCache = []
    }
    
    func testSave() {
        // given - empty store
        // when
        PokemonStore.allPokemon = testData
        // then
        guard let loaded = defaults.value(forKey: "all") as? [[String: String]] else { XCTFail("Did not save") ; return }
        XCTAssertEqual(testData.count, loaded.count)
        XCTAssertEqual(testData.count, PokemonStore._inMemoryCache.count)
    }
    
    func testLoad() {
        // given
        defaults.setValue(testData, forKey: "all")
        // when
        let loaded = PokemonStore.allPokemon
        // then
        XCTAssertEqual(testData.count,  loaded.count)
        XCTAssertEqual(testData.count, PokemonStore._inMemoryCache.count)
    }
}
