//
//  CollectionDetailsTableViewController.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class CollectionDetailsTableViewController: UITableViewController {
    var currentCollection: Collection? {
        didSet {
            navigationItem.title = currentCollection?.title
        }
    }
    var products: Products?
    var productDetails: ProductDetails?
    var productIdQueryString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        print(currentCollection ?? "")
        getProductIds()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productsCount = productDetails?.products.count {
            return productsCount
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var totalInventory = 0
        
        // Use the custom cell type
        let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell", for: indexPath) as! ProductDetailCell
        if let productName = productDetails?.products[indexPath.row].title {
            cell.productName.text = productName
        }
        
        if let collectionName = currentCollection?.title {
            cell.collectionTitle.text = collectionName
        }
        
        if let variants = productDetails?.products[indexPath.row].variants {
            for variant in variants {
                totalInventory += variant.inventory_quantity
            }
            cell.totalInventory.text = "Total: \(totalInventory)"
        }
        
        if let imageURL = productDetails?.products[indexPath.row].image.src {
            guard let data = try? Data(contentsOf: imageURL) else {
                print("Error downloading photo")
                return cell
            }
            
            cell.productImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    // MARK: - Helper method
    func getProductIds() {
        if let url = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(String(currentCollection!.id))&page=1&access_token=\(apiKey)") {
            print("url: \(url)")
            
            // Use the shared URLSession singleton object to create a data task to get the contents for the url
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                print("in the completion handler for data task for getProductIds()")
                
                if let error = error {
                    print("error: \(error)")
                    return
                }
                
                if let data = data {
                    
                    // Create an instance of JSONDecoder to decode data
                    let jsonDecoder = JSONDecoder()
                    
                    // Try to decode the returned data with the Codable Products type
                    if let result = try? jsonDecoder.decode(Products.self, from: data) {

                        for (index, item) in result.collects.enumerated() {
                            print(item.product_id)
                            self.productIdQueryString += String(item.product_id)
                            if index < (result.collects.count - 1) {
                                // append a comma if not the last id
                                self.productIdQueryString += ","
                            }
                        }
                        
                        // Update the class property to the result from decoding
                        self.products = result
                        
                        // After completion handler is done getting product id's and building the query string, then can call to query for the product details
                        self.getProductDetails()
                    }
                }
            }
            task.resume()
        }
    }
    
    func getProductDetails() {
        if let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(productIdQueryString)&page=1&access_token=\(apiKey)") {
            
            // Use the shared URLSession singleton object to create a data task to get the contents for the url
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                
                if let error = error {
                    print("error: \(error)")
                    return
                }
                
                if let data = data {
                    
                    // Create an instance of JSONDecoder to decode data
                    let jsonDecoder = JSONDecoder()
                    
                    // Try to decode the returned data with the Codable ProductDetails type
                    if let result = try? jsonDecoder.decode(ProductDetails.self, from: data) {
                        
                        // Update the class property to the result from decoding
                        self.productDetails = result

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
