//
//  CollectionsTableViewController.swift
//  ShopifyCollections
//
//  Created by Maribel Montejano on 3/24/19.
//  Copyright © 2019 Maribel Montejano. All rights reserved.
//

import UIKit

class CollectionsTableViewController: UITableViewController {
    
    // Property to store collections list from API
    var customCollections: CustomCollections?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getCollections()
    }
    
    // MARK: - Helper method
    func getCollections() {
        if let url = URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=") {
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
                    
                    // Try to decode the returned data with the Codable CustomCollections type
                    if let result = try? jsonDecoder.decode(CustomCollections.self, from: data) {
                        print("in results")
                        print(result)
                        
                        // Update the class property to the result from decoding
                        self.customCollections = result
                    }
                }
            }
            task.resume()
        }
    }
}
