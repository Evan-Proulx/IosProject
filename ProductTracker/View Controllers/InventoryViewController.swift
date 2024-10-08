//
//  InventoryViewController.swift
//  ProductTracker
//
//  Created by Evan Proulx on 2024-10-07.
//

import UIKit

class InventoryViewController: UIViewController {
    var products = [Product]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("PRODUCTS \(products)")
        // Do any additional setup after loading the view.
        
        createSnapshot()
    }
    
    //MARK: Table
    lazy var datasource = UITableViewDiffableDataSource<Section, Product>(tableView: tableView){
        tableview, indexpath, product in
        let cell = tableview.dequeueReusableCell(withIdentifier: "productCell", for: indexpath) as? InventoryTableViewCell

        cell?.productName.text = product.title
        //get poster
        self.fetchImage(forPath: product.image, inCell: cell!)
    
        return cell
    }
    
    //MARK: Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        datasource.apply(snapshot,animatingDifferences: true)
    }
    
    func fetchImage(forPath path:String,inCell cell: InventoryTableViewCell){
        //fixes url (http is not secure)
        let securePath = path.replacingOccurrences(of: "http", with: "https")

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

}
