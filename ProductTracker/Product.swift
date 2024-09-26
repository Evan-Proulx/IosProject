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

struct Product: Codable, Hashable {
    let code: String
    let total: Int
    let offset: Int
    let items: [Item]
    
    struct Item: Codable, Hashable {
        let ean: String
        let title: String
        let upc: String
        let gtin: String?
        let asin: String
        let description: String
        let brand: String
        let model: String
        let dimension: String
        let weight: String?
        let category: String
        let currency: String
        let lowestRecordedPrice: Double
        let highestRecordedPrice: Double
        let images: [String]
        let offers: [Offer]
        
        struct Offer: Codable, Hashable {
            let merchant: String
            let domain: String
            let title: String
            let currency: String
            let listPrice: Double
            let price: Double
            let shipping: String
            let condition: String
            let availability: String
            let link: String
            let updatedT: Int
            
            enum CodingKeys: String, CodingKey {
                case merchant, domain, title, currency, shipping, condition, availability, link
                case listPrice = "list_price"
                case price
                case updatedT = "updated_t"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case ean, title, upc, asin, description, brand, model, dimension, weight, category, currency, images, offers
            case lowestRecordedPrice = "lowest_recorded_price"
            case highestRecordedPrice = "highest_recorded_price"
        }
    }
}


