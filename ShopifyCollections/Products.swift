//
//  Products.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import Foundation

struct Products: Codable {
    let collects: [Product]
}

struct Product: Codable {
    let product_id: Int
}
