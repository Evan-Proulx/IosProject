//
//  ProductStore.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-10-08.
//

import Foundation

import UIKit

class ProductStore{
    private var products = Set<Product>()
    
    var numProducts: Int{
        return products.count
    }
    
    var getAllProducts: [Product]{
        return Array(products)
    }
    
    var documentDirectory: URL?{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return(paths[0])
    }
    
    //Check if product already exists in the array
    func alreadyInList(product: Product) -> Bool{
        if products.contains(product){
            return true
        }else{
            return false
        }
    }
    
    func addNewProduct(product: Product){
        products.insert(product)
        saveProducts()
        print("ProductS: \(numProducts)")
    }
    
    //If the selected product exists in the list, remove it from the array and save
    func removeProduct(product: Product){
        products.remove(product)
        saveProducts()
    }
    
    func updateProduct(withId id: Int, updatedProduct: Product) {
        if let existingProduct = products.first(where: { $0.id == id }) {
            products.remove(existingProduct)
            products.insert(updatedProduct)
            saveProducts()
        }
    }
    

    //Takes json url and updates it with the product data
    func save(to url: URL){
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(products)
            try jsonData.write(to: url)
            print("SAVED")
        } catch {
            print("Error encoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //gets data from the json url and decodes it
    func retrieve(from url: URL){
        do{
            let jsonDecoder = JSONDecoder()
            let jsonData = try Data(contentsOf: url)
            let results = try jsonDecoder.decode([Product].self, from: jsonData)
            
            //add saved products to list
            for product in results {
                products.insert(product)
            }
        } catch {
            print("Error decoding the JSON - \(error.localizedDescription)")
        }
    }
    
    //calls the save method with the correct file path to the json data
    func saveProducts(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("products.json")
        save(to: fileName)
    }
    
    //calls the retrieve method with the correct file path to the json data
    func getProducts(){
        guard let documentDirectory = documentDirectory else { return }
        let fileURL = documentDirectory.appendingPathComponent("products.json")
        retrieve(from: fileURL)
    }
}
