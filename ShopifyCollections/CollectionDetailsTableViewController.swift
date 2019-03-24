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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(currentCollection ?? "")
    }
}
