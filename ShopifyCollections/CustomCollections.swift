//
//  CustomCollections.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import Foundation

struct CustomCollections: Codable {
    let custom_collections: [Collection]
}

struct Collection: Codable {
    let id: Int
    let title: String
}
