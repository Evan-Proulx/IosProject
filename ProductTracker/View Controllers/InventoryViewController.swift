//
//  InventoryViewController.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-10-07.
//

import UIKit

class InventoryViewController: UIViewController {
    
    //MARK: Properties
    var products = [Product]()
    var productStore = ProductStore()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //retrieve data from file
        productStore.getProducts()
        //set to product store
        createSnapshot()
        
        //Add swipe gesture to the view
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(screenSwiped))
            swipeGesture.direction = .up
            view.addGestureRecognizer(swipeGesture)
        
        tableView.delegate = self
    }
    
    //MARK: Table
    lazy var datasource = UITableViewDiffableDataSource<Section, Product>(tableView: tableView){
        tableview, indexpath, product in
        let cell = tableview.dequeueReusableCell(withIdentifier: "productCell", for: indexpath) as? InventoryTableViewCell
        
        //Convert double to string
        let priceString = "$\(product.price)"

        cell?.productName.text = product.title
        cell?.productPrice.text = priceString
        //get poster
        self.fetchImage(forPath: product.image, inCell: cell!)
    
        return cell
    }
    
    //MARK: Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productStore.getAllProducts)
        datasource.apply(snapshot,animatingDifferences: true)
    }
    
    //navigate back to inventory when screen is swiped
    @objc func screenSwiped(_ sender: UISwipeGestureRecognizer){
        self.navigateToDetails()
    }
    
    func fetchImage(forPath path:String,inCell cell: InventoryTableViewCell){
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
                    cell.productImage.image = image
                }
            }
        }
        imageFetch.resume()
    }
    
    
    //Send movie data to the detailView or search screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //Nav to details
        if segue.identifier == "toDetails"{
            guard let index = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as? DetailViewController
            let productToPass = datasource.itemIdentifier(for: index)
            
            destinationVC?.product = productToPass
            destinationVC?.productStore = productStore
            destinationVC?.navFromSearch = false
            
        //Nav to search
        }else if segue.identifier == "toSearch"{
            let destinationVC = segue.destination as? ViewController
            destinationVC?.productStore = productStore
        }
    }
    
    func navigateToDetails(){
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "search") as? ViewController {
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}

//allow for swiping on row to delete record
extension InventoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove"){
            _, _, completionHandler in
            guard let productToRemove = self.datasource.itemIdentifier(for: indexPath) else{return}
            
            //alert before deleting
            let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to remove this product?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive){
                _ in
                //delete product
                self.productStore.removeProduct(product: productToRemove)
                self.createSnapshot()
                
                completionHandler(true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){
                _ in
            })
            //show alert
            self.present(alert, animated: true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

