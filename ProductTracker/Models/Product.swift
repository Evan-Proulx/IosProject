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

struct Product: Codable, Hashable{
    static var lastId: Int = 0
        
    var id: Int
    var title: String
    var description: String
    var brand: String
    var price: Double
    var image: String
    
    init(title: String, description: String, brand: String, price: Double, image: String) {
        self.id = Product.lastId
        Product.lastId += 1
        self.title = title
        self.description = description
        self.brand = brand
        self.price = price
        self.image = image
    }
}
