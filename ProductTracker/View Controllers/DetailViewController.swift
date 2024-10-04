//
//  DetailViewController.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-10-03.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var product: Product!
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.title
        brand.text = product.brand
        details.text = product.description
        price.text = String(product.price)
        
        fetchImage(forPath: product.image)
        
        

    }

    func fetchImage(forPath path:String){
        
        guard let imageURL = URL(string: path) else {
            print("Can't make this url: \(path)")
            return
        }
        let imageFetch = URLSession.shared.downloadTask(with: imageURL){
            url, response, error in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                //set image
                DispatchQueue.main.async{
                    self.image.image = image
                }
            }
        }
        imageFetch.resume()
    }
}
