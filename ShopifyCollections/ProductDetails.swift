//
//  ProductDetails.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import Foundation

struct ProductDetails: Codable {
    let products: [ProductDetail]
}

struct ProductDetail: Codable {
    let id: Int
    let title: String
    let variants: [Variant]
}

struct Variant: Codable {
    let inventory_quantity: Int
}
