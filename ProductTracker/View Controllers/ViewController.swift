//
//  ViewController.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-09-25.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var textField: UITextField!
    var product: Product?
    var productStore: ProductStore!
        
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //search for product with input given
    @IBAction func search(_ sender: Any) {
        guard let code = textField.text, !code.isEmpty, code.count == 12 else {
            //Show custom alert when code is invalid
            displayDialog()
            
            return
        }
        
        let url = createUrl(code: code)!
        searchItem(url: url)
    }
    
    func displayDialog(){
        let warningDialog = WarningDialog()
        warningDialog.frame = view.bounds
        warningDialog.isOpaque = false
        
        view.addSubview(warningDialog)
        view.isUserInteractionEnabled = true

        warningDialog.showDialog()
        return
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
    
    //Get searched product from api
    func searchItem(url: URL){
        //get results
        let productTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let dataError = error {
                print("Error fetching results: \(dataError.localizedDescription)")
            } else {
                guard let fetchedData = data else {
                    self.displayDialog()
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: fetchedData, options: []) as? [String: Any] {
                        if let items = json["items"] as? [[String: Any]], let firstItem = items.first {
                            
                            // Extract values from json
                            let title = firstItem["title"] as? String ?? "No title"
                            let description = firstItem["description"] as? String ?? "No title"
                            let brand = firstItem["brand"] as? String ?? "No brand"
                            let price = firstItem["highest_recorded_price"] as? Double ?? 0.0
                            
                            // Get the first image URL from the images array
                            let images = firstItem["images"] as? [String] ?? []
                            let image = images.first ?? "No image"
                            
                            // Create product with values
                            let product = Product(title: title,description: description, brand: brand, price: price, image: image)
                            
                            DispatchQueue.main.async {
                                print(product)
                                self.product = product
                                
                                //navigate once product is found
                                self.navigateToDetails()
                            }
                        }
                    }else{self.displayDialog()}
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
        productTask.resume()
    }
    
    
    func navigateToDetails(){
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailViewController {
            
            destinationVC.navFromSearch = true
            destinationVC.product = product
            destinationVC.productStore = productStore
            destinationVC.navFromSearch = true
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
}
