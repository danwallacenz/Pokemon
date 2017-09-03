//
//  Pokemon.swift
//  Pokemon
//
//  Created by Daniel Wallace on 2/09/17.
//  Copyright © 2017 danwallacenz. All rights reserved.
//

import Foundation
import UIKit

struct Pokemon: Codable {
    let id: String
    let name: String
    let weight: Int
    let height: Int
    let images: [String: URL]
    var pngs: [String: UIImage]? = [:]
    
    mutating func addPNG(for key: String, image: UIImage) {
        pngs?[key] = image
    }
    
    private enum CodingKeys: CodingKey {
        case id
        case name
        case weight
        case height
        case images
        case pngs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        weight = try container.decode(Int.self, forKey: .weight)
        height = try container.decode(Int.self, forKey: .height)
        images = try container.decode([String: URL].self, forKey: .images)
        //pngs = try container.decode([String: UIImage].self, forKey: .pngs)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(weight, forKey: .weight)
        try container.encode(height, forKey: .height)
        try container.encode(images, forKey: .images)
        //try container.encode(pngs, forKey: .pngs)
    }
    
    init(id: String, name: String, weight: Int, height: Int, images: [String: URL], pngs: [String: UIImage]? = nil ) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.images = images
    }
}
