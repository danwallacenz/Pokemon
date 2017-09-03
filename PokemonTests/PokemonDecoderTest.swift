//
//  PokemonDecoderTest.swift
//  PokemonTests
//
//  Created by Daniel Wallace on 31/08/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import XCTest
@testable import Pokemon

class PokemonDecoderTest: XCTestCase {
    
    func testDecodeAll() {
        // given
        guard let testData = PokemonTestData.all.data(using: .utf8) else { XCTFail("No test data"); return }
        
        // when
        let decoded = PokemonDecoder.decode(data: testData)
        
        // then
        XCTAssertNotNil(decoded)
        XCTAssertEqual(4, decoded!.baseURL.pathComponents.count)
        XCTAssertEqual("https://pokeapi.co/api/v2/pokemon/", decoded!.baseURL.absoluteString)
        
        guard let decodedCount = PokemonDecoder.decodeCount(from: testData) else { XCTFail("No count"); return }
        XCTAssertEqual(decodedCount, decoded!.data.count)
    }
    
    func testPokemonCodable() {
        // given
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/10060.png") else { XCTFail("my bad url"); return }
         guard let png = UIImage.init(named: "test_png") else { XCTFail("my bad png"); return }
        let myPokemon = Pokemon(id: "111", name: "Pokemon1", weight: 73, height: 22, images: ["image1" : url], pngs: [png])
        
        // when (encoding)
        guard let data = PokemonDecoder.encode(pokemon: myPokemon) else { XCTFail("Could not encode"); return }
        
        //then
        XCTAssert(data.count > 0)
        
        // when (decoding)
        guard let myDecodedPokemon = PokemonDecoder.decode(pokemon: data) else { XCTFail("Could not decode"); return }
        
        // then
        XCTAssertEqual(myPokemon.id, myDecodedPokemon.id)
        XCTAssertEqual(myPokemon.name, myDecodedPokemon.name)
        XCTAssertEqual(myPokemon.height, myDecodedPokemon.height)
        XCTAssertEqual(myPokemon.weight, myDecodedPokemon.weight)
        XCTAssertEqual(myPokemon.images, myDecodedPokemon.images)
        XCTAssertEqual(1, myPokemon.images.count)
        XCTAssertEqual(myPokemon.pngs.count, myDecodedPokemon.pngs.count)
        XCTAssertEqual(1, myPokemon.pngs.count)
    }
}
