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
        
        guard let decodedCount = PokemonDecoder.decodeCount(from: testData) else { XCTFail("No count"); return }
        
        XCTAssertEqual(decodedCount, decoded!.count)
        
//        guard let first = decoded?.first, first.count == 1 else { XCTFail("Weird"); return }
//        guard let _ = Int(first.values.first!) else {XCTFail("Bad key (not an Int)"); return} // needed? assumes key is an Int
    }
    
    func testDecodeAll2() {
        
        // given
        guard let testData = PokemonTestData.all.data(using: .utf8) else { XCTFail("No test data"); return }
        
        // when
        let decoded = PokemonDecoder.decode2(data: testData)
        
        // then
        XCTAssertNotNil(decoded)
        XCTAssertEqual(4, decoded!.baseURL.pathComponents.count)
        XCTAssertEqual("https://pokeapi.co/api/v2/pokemon/", decoded!.baseURL.absoluteString)
        
        guard let decodedCount = PokemonDecoder.decodeCount(from: testData) else { XCTFail("No count"); return }
        XCTAssertEqual(decodedCount, decoded!.data.count)
    }
}
