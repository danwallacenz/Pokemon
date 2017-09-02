//
//  Pokemon.swift
//  Pokemon
//
//  Created by Daniel Wallace on 2/09/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation
import UIKit

struct Pokemon {
    let id: String
    let name: String
    let weight: Int
    let height: Int
    let images: [String: URL]
    var pngs: [String: UIImage]? = [:]
    
    mutating func addPNG(for key: String, image: UIImage) {
        pngs?[key] = image
    }
}
