//
//  Product.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-09-26.
//

import Foundation

enum Section{
    case main
}

struct Product {
    let title: String
    let description: String
    let brand: String
    let price: Double
    let image: String
}
