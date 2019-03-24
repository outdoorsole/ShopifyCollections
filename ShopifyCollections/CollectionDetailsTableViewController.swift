//
//  CollectionDetailsTableViewController.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class CollectionDetailsTableViewController: UITableViewController {
    var currentCollection: Collection?
    var products: Products?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentCollection ?? "")
        getProductDetails()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productsCount = products?.collects.count {
            return productsCount
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        if let productId = products?.collects[indexPath.row].product_id {
            cell.textLabel?.text = String(productId)
        }
        
        return cell
    }
    
    // MARK: - Helper method
    func getProductDetails() {
        if let url = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(String(currentCollection!.id))&page=1&access_token=") {
            print("url: \(url)")
            
            // Use the shared URLSession singleton object to create a data task to get the contents for the url
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                print("in the completion handler for data task")
                
                if let error = error {
                    print("error: \(error)")
                    return
                }
                
                if let data = data {
                    print("data \(data)")
                    
                    // Create an instance of JSONDecoder to decode data
                    let jsonDecoder = JSONDecoder()
                    
                    // Try to decode the returned data with the Codable Products type
                    if let result = try? jsonDecoder.decode(Products.self, from: data) {
                        print("in results")
                        print(result)
                        
                        // Update the class property to the result from decoding
                        self.products = result
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
