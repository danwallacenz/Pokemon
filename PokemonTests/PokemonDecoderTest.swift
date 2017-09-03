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
}
