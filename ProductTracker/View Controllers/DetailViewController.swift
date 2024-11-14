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
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var product: Product!
    var productStore: ProductStore!
    var navFromSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide addButton if it's already in the inventory
        if !navFromSearch{
            addButton.isHidden = true
        }else{addButton.isHidden = false}
        
        //Product details
        productTitle.text = product.title
        brand.text = product.brand
        details.text = product.description
        price.text = String("$\(product.price)")
        
        fetchImage(forPath: product.image)
        
        //add hold gesture to the priceLabel
        price.isUserInteractionEnabled = true
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(priceLongPressed))
        
        price.addGestureRecognizer(holdGesture)
        
        
        //Add swipe gesture to the view
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(screenSwiped))
            swipeGesture.direction = .right
            view.addGestureRecognizer(swipeGesture)
    }

    @IBAction func editPrice(_ sender: Any) {
        updatePrice()
    }
    
    //update price when price text is long held
    @objc func priceLongPressed(_ sender: UILongPressGestureRecognizer){
        updatePrice()
    }
    
    //navigate back to inventory when screen is swiped
    @objc func screenSwiped(_ sender: UISwipeGestureRecognizer){
        navigationController?.popViewController(animated: true)
    }
    //display alert to update price
    func updatePrice(){
        let ac = UIAlertController(title: "Edit Price", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            //set to decimal keyboard
            textField.keyboardType = .decimalPad
        }
        
        ac.addAction(UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            let userInput = ac.textFields?[0].text ?? "0"
            let numInput = Double(userInput)
            if let numInput = numInput{
                self.product.price = numInput
                //update label
                self.price.text = String(format: "$%.2f", numInput)
                //update the product in the store
                productStore.updateProduct(withId: product.id, updatedProduct: product)
                print(product.price)
                //update the page
                viewDidLoad()
            }
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }
    
    func fetchImage(forPath path:String){
        //fixes url (http is not secure)
        let securePath = path.replacingOccurrences(of: "http:", with: "https:")

        guard let imageURL = URL(string: securePath) else {
            print("Can't make this url: \(securePath)")
            return
        }
        print(imageURL)
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
    
    
    //Navigate to inventory when product is added
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationVC = segue.destination as? InventoryViewController
        
        //Add product to store
        productStore.addNewProduct(product: product)
    }
}
