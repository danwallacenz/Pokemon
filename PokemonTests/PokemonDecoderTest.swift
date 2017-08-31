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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecodeAll() {
        
        guard let testData = PokemonTestData.all.data(using: .utf8) else { XCTFail("No test data"); return }
        
        let decoded = PokemonDecoder.decode(data: testData)
        XCTAssertNotNil(decoded)
        
        guard let decodedCount = PokemonDecoder.decodeCount(from: testData) else { XCTFail("No count"); return }
        
        XCTAssertEqual(decodedCount, decoded!.count)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
