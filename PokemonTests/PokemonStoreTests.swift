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
    let testData = ["Pokemon1":  ["id": "1"], "Pokemon2": ["id": "2"]]
    
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
        defaults.setValue(nil, forKey: "baseURL")
        PokemonStore._inMemoryCache = [:]
    }
    
    func testSavePokemon() {
        // given - empty store
        // when
        PokemonStore.allPokemon = testData
        // then
        guard let loaded = defaults.value(forKey: "all") as? [String: [String: String]] else { XCTFail("Did not save") ; return }
        XCTAssertEqual(testData.count, loaded.count)
        XCTAssertEqual(testData.count, PokemonStore._inMemoryCache.count)
    }
    
    func testLoadPokemon() {
        // given
        defaults.setValue(testData, forKey: "all")
        // when
        let loaded = PokemonStore.allPokemon
        // then
        XCTAssertEqual(testData.count,  loaded.count)
        XCTAssertEqual(testData.count, PokemonStore._inMemoryCache.count)
    }
    
    func testSaveBaseURL() {
        // given
        let testURL = URL(string: "https://testpokeapi.co/api/v2/pokemon/")
        // when
        PokemonStore.baseURL = testURL
        // then
        guard let loadedURL = defaults.url(forKey: "baseURL") as? URL else { XCTFail("Did not save URL") ; return }
        XCTAssertEqual(testURL, loadedURL)
    }
    
    func testLoadBaseURL() {
        // given
        let testURL = URL(string: "https://testpokeapi.co/api/v2/pokemon/")
        defaults.set(testURL, forKey: "baseURL")
        // when
        let loadedURL = PokemonStore.baseURL
        // then
        XCTAssertEqual(testURL, loadedURL)
    }
    
    func testIdForPokemonName() {
        // given - empty store
        PokemonStore.allPokemon = testData
        // when
        let id = PokemonStore.id(for: "Pokemon1")
        XCTAssertEqual("1", id)
    }
}
