//
//  ViewController.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-09-25.
//

import UIKit

class ViewController: UIViewController {
    
    var products = [Product]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var code = "885909950805"
        
        var url = createUrl(code: code)!
        searchItem(url: url)
    }

    
    func searchItem(url: URL){
        //get results
        let productTask = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let dataError = error {
                print("Error fetching results: \(dataError.localizedDescription)")
            }else{
                guard let fetchedData = data else { return }
                print(fetchedData)
                do{
                //get movie poster
                    let jsonDecoder = JSONDecoder()
                    let downloadedResults = try jsonDecoder.decode(Product.self, from: fetchedData)
                    
                    print(downloadedResults)
                    //fill table with movies
                    DispatchQueue.main.async {
                    }
                } catch DecodingError.valueNotFound(let type, let context){
                    print("Error - value not found \(type): \(context)")
                } catch DecodingError.typeMismatch(let type, let context){
                    print("Error - types do not match \(type): \(context)")
                } catch DecodingError.keyNotFound(let key, let context){
                    print("Error - missing key \(key): \(context)")
                } catch{
                    print("Problem decoding: \(error.localizedDescription)")
                }
            }
        }
        productTask.resume()
    }
    
    //creates url with search and api key
    func createUrl(code: String) -> URL?{
        //create url
        guard let cleanURL = code.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { fatalError("Can't make a url from: \(code)")}
        var urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc="
        urlString = urlString.appending(cleanURL)
        print(urlString)
        
        return URL(string: urlString)
    }

    

}

